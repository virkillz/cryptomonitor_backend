defmodule ExchangeScanner do
  @moduledoc """
  ExchangeScanner keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_currencies do
    ["USD", "THB", "EUR", "BTC"]
  end

  def list_exchanges do
    [
      %{
        id: 1,
        symbol: "binance",
        name: "Binance",
        logo: "/images/exchange/binance.png",
        url: "www.binance.com",
        visible: true,
        year: 2017,
        description:
          "Binance is a China-based cryptocurrency exchange that lists most of the Chinese coins. It is a popular exchange for its huge number of Initial Coin Offering (ICO) listings and low fees.\r\nThe token issued by this exchange is <a href=\"https://www.coingecko.com/en/coins/binancecoin\">Binance Coin</a> which give users voting rights and trading fee discounts."
      },
      %{
        id: 2,
        symbol: "coinbene",
        name: "Coinbene",
        logo: "/images/exchange/coinbene.png",
        url: "www.coinbene.com",
        visible: false,
        year: 2017,
        description: "-"
      },
      %{
        id: 3,
        symbol: "okex",
        name: "Okex",
        logo: "/images/exchange/okex.png",
        url: "www.okex.com",
        visible: true,
        year: 2013,
        description:
          "OKEx is a Hong Kong based crypto to crypto exchange that offers token trading, spot and futures trading. It also offers margin trading for users that would like to trade on leverage. "
      },
      %{
        id: 4,
        symbol: "coineal",
        name: "Coineal",
        logo: "/images/exchange/coineal.png",
        url: "www.coineal.com",
        visible: true,
        year: 2018,
        description:
          "Coineal, found online at Coineal.com, is a cryptocurrency exchange founded by a team based in South Korea and China.\r\n\r\nThe exchange was announced on April 24, 2018. The exchange also announced plans to launch its own “NEAL” token.\r\n\r\nOne of the unique things about Coineal is that it will be South Korea’s first decentralized exchange. The exchange will operate across a series of nodes based worldwide. Nodes will receive NEAL tokens in exchange for their processed transaction volume. Furthermore, nodes will be asked to participate in various aspects of running the exchange – including democratic governance decisions."
      },
      %{
        id: 5,
        symbol: "tokenomy",
        name: "Tokenomy",
        logo: "/images/exchange/tokenomy.png",
        url: "www.tokenomy.com",
        visible: true,
        year: 2018,
        description:
          "A marketplace for valuable tokens to be listed and traded on the crypto-only exchange. The platform enables an easy transformation of any valuable offering into blockchain tokens, allowing companies and organizations to distribute & exchange their tokens."
      },
      %{
        id: 6,
        symbol: "bitfinex",
        name: "Bitfinex",
        logo: "/images/exchange/bitfinex.png",
        url: "www.bitfinex.com",
        visible: true,
        year: 2018,
        description:
          "BItfinex is one of the most liquid exchange in the world with over 20+ cryptocurrencies listed. It also features margin trading and margin funding market for users to trade with up to 3.3x leverage and earn interest by providing funding to traders wanting to trade with leverage. \r\n\r\nBitfinex prioritizes security of funds and user information by requiring users to enable 2FA using Google Authenticator, Twilio, or a U2F Security Key. To protect security of funds, majority of system funds are stored in cold wallets and only approx. 0.5% of crypto assets are accessibile in hot wallets for day-to-day platform operations."
      },
      %{
        id: 7,
        symbol: "indodax",
        name: "Indodax",
        logo: "/images/exchange/indodax.png",
        url: "www.bitfinex.com",
        visible: true,
        year: 2014,
        description:
          "Indodax (Previously known as Bitcoin Indonesia) is the largest bitcoin & digital assets exchange in Indonesia. It allows users to buy/sell bitcoin and other cryptocurrencies such as ethereum, litecoin, zcoin, and more with Indonesian Rupiah.\r\n\r\nIndodax is a rebrand movement spearheaded by its CEO, Oscar Darmawan to realign the company's goal to focus on various digital assets rather than just bitcoin."
      },
      %{
        id: 8,
        symbol: "kucoin",
        name: "Kucoin",
        logo: "/images/exchange/kucoin.png",
        url: "www.kucoin.com",
        visible: true,
        year: 2014,
        description:
          "Kucoin is a Hong Kong-based international cryptocurrency exchange, with support for both NEO and GAS markets. \r\nKucoin is the second exchange to distribute GAS to NEO holders, and the first exchange to distribute GAS daily. The first exchange to do so is Binance, which distributes GAS to NEO holders on a monthly basis."
      }
    ]
  end

  def list_coins do
    [
      %{
        name: "Bitcoin",
        symbol: "BTC",
        logo: "/images/coin/btc.png"
      },
      %{
        name: "Ethereum",
        symbol: "ETH",
        logo: "/images/coin/eth.png"
      },
      %{
        name: "Litecoin",
        symbol: "LTC",
        logo: "/images/coin/ltc.png"
      },
      %{
        name: "Bitcoin Cash",
        symbol: "BCH",
        logo: "/images/coin/bch.png"
      },
      %{
        name: "Ripple",
        symbol: "XRP",
        logo: "/images/coin/xrp.png"
      },
      %{
        name: "EOS",
        symbol: "EOS",
        logo: "/images/coin/eos.png"
      },
      %{
        name: "Binance Coin",
        symbol: "BNB",
        logo: "/images/coin/bnb.png"
      },
      %{
        name: "Tether",
        symbol: "USDT",
        logo: "/images/coin/usdt.png"
      },
      %{
        name: "Stellar",
        symbol: "XLM",
        logo: "/images/coin/xlm.png"
      },
      %{
        name: "Cardano",
        symbol: "ADA",
        logo: "/images/coin/ada.png"
      },
      %{
        name: "Tron",
        symbol: "TRX",
        logo: "/images/coin/trx.png"
      },
      %{
        name: "Monero",
        symbol: "XMR",
        logo: "/images/coin/xmr.png"
      }
    ]
  end

  def get_arbitrage_info(pair, list_exchange) do
    all_result =
      list_exchange
      |> validate_list
      |> Enum.map(fn x ->
        Task.async(fn -> apply(Monitrage, :get_order_book, [String.to_atom(x), pair]) end)
      end)
      |> Enum.map(fn x -> Task.await(x) end)
      |> Enum.filter(fn {k, v} -> k == :ok end)
      |> Enum.map(fn {k, v} -> v end)
      |> Enum.map(fn x -> put_float_bid(x) end)
      |> Enum.map(fn x -> put_float_ask(x) end)

    max_bid = Enum.max_by(all_result, & &1[:float_bid])

    min_ask = Enum.min_by(all_result, & &1[:float_ask])

    %{
      min_ask: min_ask.float_bid,
      max_bid: max_bid.float_ask,
      all_result: all_result,
      profit: max_bid.float_bid - min_ask.float_ask,
      lowest_ask: min_ask,
      highest_bid: max_bid,
      gain: (max_bid.float_bid - min_ask.float_ask) / min_ask.float_ask * 100
    }
  end

  def is_coin_supported?(coin) do
    supported_coins = list_coins() |> Enum.map(& &1[:symbol])

    if Enum.member?(supported_coins, String.upcase(coin)) do
      true
    else
      false
    end
  end

  def get_arbitrage_pair(coin) do
    case coin do
      "BTC" -> "btc_usdt"
      other -> String.downcase(other) <> "_btc"
    end
  end

  def put_details(%{all_result: exchanges}) do
    exchanges
    |> Enum.map(fn x -> put_detail(x) end)
  end

  def put_detail(%{exchange: symbol} = map) do
    case find_exchange_by_symbol(symbol) do
      nil -> map |> Map.put(:url, "") |> Map.put(:logo, "")
      result -> map |> Map.put(:url, result.url) |> Map.put(:logo, result.logo)
    end
  end

  def get_coin_info(coin) do
    result =
      list_coins()
      |> Enum.filter(fn x -> x.symbol == String.upcase(coin) end)

    case result do
      [one] -> one
      _other -> nil
    end
  end

  def find_exchange_by_symbol(symbol) do
    result =
      list_exchanges()
      |> Enum.filter(fn x -> x.symbol == symbol end)

    case result do
      [one] -> one
      _other -> nil
    end
  end

  def put_details(map) do
    []
  end

  defp put_float_bid(map) do
    case map do
      %{exchange: exchange, higest_bid: [bid, vol]} -> Map.put(map, :float_bid, float_parse(bid))
      _ -> %{}
    end
  end

  defp put_float_ask(map) do
    case map do
      %{exchange: exchange, lowest_ask: [ask, vol]} -> Map.put(map, :float_ask, float_parse(ask))
      _ -> %{}
    end
  end

  defp float_parse(string) do
    {float, _} = Float.parse(string)
    float
  end

  def validate_list(list_exchange) do
    supported_exchange = Enum.map(list_exchanges(), & &1[:symbol])

    list_exchange
    |> Enum.filter(fn x -> Enum.member?(supported_exchange, x) end)
  end
end
