defmodule ExchangeScanner.Subscriber do
  @moduledoc "This is the genserver example when you want to subscribe into arbitrage signal."
  use GenServer

  # Callbacks

  def start_link(_whtvr) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(stack) do
    # --- put this to subscribe to arbitrage signal
    {:ok, _} = Registry.register(:monitrage_registry, "arbitrage_signal", [])

    # --- put this to subscribe to know which pair is currently under scanning
    {:ok, _} = Registry.register(:monitrage_registry, "current_pair", [])

    {:ok, stack}
  end

  # --- If you register to "arbitrage_signal" in init, you HAVE to implement following handler."
  @impl true
  def handle_info({:arbitrage_signal, result}, state) do
    if result.base == "BTC" do
      case Cachex.get(:my_cache, "best_record") do
        {:ok, nil} ->
          Cachex.put(:my_cache, "best_record", result)
          ExchangeScannerWeb.Endpoint.broadcast("room:public", "new_record", %{record: result})

        {:ok, record} ->
          {old, _} = Float.parse(record.profit)
          {new, _} = Float.parse(result.profit)

          if new > old do
            Cachex.put(:my_cache, "best_record", result)
            ExchangeScannerWeb.Endpoint.broadcast("room:public", "new_record", %{record: result})
          end

        other ->
          :nothing
      end
    else
    end

    case Cachex.get(:my_cache, "signal") do
      {:ok, nil} -> Cachex.put(:my_cache, "signal", [result])
      {:ok, list} -> Cachex.put(:my_cache, "signal", [result | list])
    end

    {:ok, count} = Cachex.incr(:my_cache, "signal_counter", 1, initial: 0)
    # IO.inspect(result)

    date = result.time |> DateTime.from_unix!() |> DateTime.to_string()

    summary = "Buy #{result.asset} from #{result.buy_from} and sell to #{result.sell_to}"

    ExchangeScannerWeb.Endpoint.broadcast("room:public", "arbitrage_signal", %{
      result: result,
      count: count,
      date: date,
      summary: summary
    })

    {:noreply, state}
  end

  # --- If you register to "current_pair" in init, you HAVE to implement following handler."
  @impl true
  def handle_info({:current_pair, result}, state) do
    [asset, base] = String.split(result, "_")
    pair = String.upcase(asset) <> " - " <> String.upcase(base)

    {:ok, scan_count} = Cachex.incr(:my_cache, "scan_counter", 1, initial: 0)

    ExchangeScannerWeb.Endpoint.broadcast("room:public", "current_pair", %{
      pair: pair,
      scan_count: scan_count
    })

    # --- do whatever you want with the information
    # IO.inspect("currently process #{result}")
    {:noreply, state}
  end
end
