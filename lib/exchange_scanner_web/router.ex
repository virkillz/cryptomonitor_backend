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
  end

  scope "/", ExchangeScannerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/coins", PageController, :coins 
    get "/coins/:coin", PageController, :coin_detail   
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExchangeScannerWeb do
  #   pipe_through :api
  # end
end
