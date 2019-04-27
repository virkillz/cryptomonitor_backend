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
    render(conn, "coin_detail.html")
  end    
end
