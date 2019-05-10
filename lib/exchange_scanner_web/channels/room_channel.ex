defmodule ExchangeScannerWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:public", message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  def join("private", _message, socket) do
    {:ok, socket}
  end

  def join(_room, _params, _socket) do
    {:error, "You can only join lobby"}
  end
end
