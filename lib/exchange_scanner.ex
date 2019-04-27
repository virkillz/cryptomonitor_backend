defmodule ExchangeScanner do
  @moduledoc """
  ExchangeScanner keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

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

end
