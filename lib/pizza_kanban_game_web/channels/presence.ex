defmodule PizzaKanbanGameWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](http://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence, otp_app: :pizza_kanban_game,
                        pubsub_server: PizzaKanbanGame.PubSub
end
