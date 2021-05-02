defmodule PizzaKanbanGameWeb.GameStore do
  use PizzaKanbanGameWeb.Store
  alias PizzaKanbanGame.Game

  def save(%Game{id: id} = game) do
    persist(id, game)
  end
end
