defmodule PizzaKanbanGameWeb.GameStore do
  use PizzaKanbanGameWeb.Store
  alias PizzaKanbanGame.Game

  require Logger

  def save(%Game{id: id} = game) do
    {:ok, persist(id, game)}
  end

  def update_table({:error, _reason}=error, _table_name, _toppings) do
    Logger.info("update table error = #{inspect(error)}")
    error
  end

  def update_table({:ok, %Game{id: id, tables: tables}=game}, table_name, toppings) do
    Logger.info("update table ok = #{inspect(game)}, table_name = #{inspect(table_name)}, toppings=#{inspect(toppings)}")
    tables = Map.put(tables, table_name, toppings)
    Logger.info("tables = #{inspect(tables)}")
    new_game = %{game | tables: tables }
    {:ok, persist(id, new_game)}
  end
end
