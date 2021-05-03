defmodule PizzaKanbanGame.PlayerStore do
  use PizzaKanbanGame.Store
  alias PizzaKanbanGame.{Player, Utils, Namer}

  def save(%{id: id, name: name}) do
    persist(id, %{id: id, name: name})
  end

  def create() do
    name = Namer.make()
    with {:ok, player} <- get_by(&has_name?(&1, name)) do
      create()
    else
      _ ->
        player = {name} |> Player.new() |> save()
        {:ok, player}
    end
  end

  def has_name?(%{name: player_name}, name), do: Utils.string_equals?(player_name, name)
end
