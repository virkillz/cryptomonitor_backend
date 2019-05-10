defmodule ExchangeScannerWeb.PageController do
  use ExchangeScannerWeb, :controller

  def index(conn, _params) do
    render(conn, "scanner.html")
  end

  def coins(conn, _params) do
    coins = ExchangeScanner.list_coins()
    render(conn, "coin.html", coins: coins)
  end

  def coin_detail(conn, %{"coin" => coin}) do
    if ExchangeScanner.is_coin_supported?(coin) do
      coin_info = ExchangeScanner.get_coin_info(coin)

      arbit_info =
        coin
        |> ExchangeScanner.get_arbitrage_pair()
        |> ExchangeScanner.get_arbitrage_info([
          "binance",
          "tokenomy",
          "indodax",
          "bitfinex",
          "kucoin"
        ])

      results = arbit_info |> ExchangeScanner.put_details()
      render(conn, "coin_detail.html", info: arbit_info, results: results, coin_info: coin_info)
    else
      render(conn, "coin_detail.html", layout: {ExchangeScannerWeb.LayoutView, "app_blank.html"})
    end
  end

  def api_coin_detail(conn, %{"coin" => coin, "exchange" => exchanges}) when is_list(exchanges) do
    if ExchangeScanner.is_coin_supported?(coin) do
      coin_info = ExchangeScanner.get_coin_info(coin)

      arbit_info =
        coin
        |> ExchangeScanner.get_arbitrage_pair()
        |> ExchangeScanner.get_arbitrage_info(exchanges)

      results = arbit_info |> ExchangeScanner.put_details()

      info = %{
        "coin" => coin_info,
        "detail" => %{
          "buy_from" => arbit_info.highest_bid.exchange |> String.capitalize,
          "sell_to" => arbit_info.lowest_ask.exchange |> String.capitalize,
          "summary" => "Buy from #{arbit_info.highest_bid.exchange |> String.capitalize}, Sell at #{arbit_info.lowest_ask.exchange |> String.capitalize}",
          "deal_percentage" => "#{(arbit_info.gain * 100) |> Float.ceil(2)}" ,
          "buy_price" => arbit_info.min_ask,
          "sell_price" => arbit_info.max_bid,
          "currency" => arbit_info.highest_bid.pair |> get_base
          },
          "results" => results
      }

      conn
      |> json(info)
    else
      conn |> put_status(400) |> json(%{"message" => "bad parameter njink"})
    end
  end

  def get_base(pair) do
    [a, b] = String.split(pair, "_")
    String.upcase(b)
  end

  def api_coin_detail(conn, params) do
    conn |> put_status(400) |> json(%{"message" => "bad parameter"})
  end

  def api_coins(conn, _params) do
    coins = ExchangeScanner.list_coins()
    json(conn, coins)
  end

  def api_exchanges(conn, _params) do
    exchanges = ExchangeScanner.list_exchanges()
    json(conn, exchanges)
  end

  def api_combined(conn, _params) do
    coins = ExchangeScanner.list_coins()
    exchanges = ExchangeScanner.list_exchanges()
    json(conn, %{"coins" => coins, "exchanges" => exchanges})
  end

  def exchanges(conn, _params) do
    exchanges = ExchangeScanner.list_exchanges()
    render(conn, "exchanges.html", exchanges: exchanges)
  end

  def setting(conn, _params) do
    conn.assigns[:cur]
    currencies = ExchangeScanner.list_currencies()
    default_currency = "USD"
    exchanges = ExchangeScanner.list_exchanges()

    render(conn, "setting.html",
      exchanges: exchanges,
      default_currency: default_currency,
      currencies: currencies
    )
  end
end
