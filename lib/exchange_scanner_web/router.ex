defmodule ExchangeScannerWeb.Router do
  use ExchangeScannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: ["http://localhost:3000", "http://127.0.0.1:3000"]
  end

  scope "/", ExchangeScannerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/coins", PageController, :coins
    get "/setting", PageController, :setting
    get "/exchanges", PageController, :exchanges
    get "/coins/:coin", PageController, :coin_detail
  end

  # Other scopes may use custom stacks.
  scope "/api", ExchangeScannerWeb do
    pipe_through :api

    get "/best", PageController, :api_coin_detail
    get "/resources", PageController, :api_combined
    get "/coins", PageController, :api_coins
    get "/exchanges", PageController, :api_exchanges
  end
end
