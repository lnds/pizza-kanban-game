defmodule PizzaKanbanGameWeb.GameStore do
  use PizzaKanbanGameWeb.Store
  alias PizzaKanbanGame.Game

  require Logger

  def save(%Game{id: id} = game) do
    {:ok, persist(id, game)}
  end

  def update_table({:error, _reason}=error, _table_name, _toppings), do: error

  def update_table({:ok, %Game{id: id, tables: tables}=game}, table_name, topping) do
    if tables == nil do
      tables = %{table_name: [topping]}
      new_game = %{game | tables: tables }
      {:ok, persist(id, new_game)}
    else
      table = Map.get(tables, table_name)
      if table == nil do
        new_game = %{game | tables: Map.put(tables, table_name, [topping]) }
        {:ok, persist(id, new_game)}
      else
        new_game = %{game | tables: Map.put(tables, table_name, table ++ [topping]) }
        {:ok, persist(id, new_game)}
      end
    end
  end

  def pop_table({:error, _reason}=error, _table_name), do: error

  def pop_table({:ok, %Game{id: id, tables: tables}=game}, table_name) do
    if tables == nil do
      tables = %{table_name: []}
      new_game = %{game | tables: tables }
      {:ok, persist(id, new_game)}
    else
      table = Map.get(tables, table_name)
      if table == nil do
        {:ok, persist(id, game)}
      else
        new_game = %{game | tables: Map.put(tables, table_name, Enum.drop(table, -1)) }
        {:ok, persist(id, new_game)}
      end
    end
  end

  def get_table({:error, _reason}=error, _table_name), do: error

  def get_table({:ok, %Game{id: _id, tables: tables}}, table_name) do
    if tables == nil do
      {:ok, []}
    else
      {:ok, Map.get(tables, table_name)}
    end
  end

end
