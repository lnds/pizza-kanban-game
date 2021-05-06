defmodule PizzaKanbanGame.GameStore do
  use PizzaKanbanGame.Store
  alias PizzaKanbanGame.Game

  require Logger

  def save(%Game{id: id} = game) do
    {:ok, persist(id, game)}
  end



end
