defmodule PizzaKanbanGame.GameChannel do
  use PizzaKanbanGameWeb, :channel

  require Logger

  def join(channel_name, _params, socket) do
    Logger.info("RoomChannel join #{inspect(channel_name)}")
    {:ok, %{channel: channel_name}, socket}
  end
end
