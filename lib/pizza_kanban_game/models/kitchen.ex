defmodule PizzaKanbanGame.Models.Kitchen do

  use StructAccess

  require Logger

  defstruct id: "kitchen",
            tables: []

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{Kitchen, Table}

  @spec new(integer) :: PizzaKanbanGame.Models.Kitchen.t()
  def new(n),  do:
    %Kitchen {
      tables: Enum.map(1..n, fn i -> Table.new("table_#{i}") end)
    }

  def drop(kitchen, table_name, ingredient) do
    Enum.find(kitchen.tables, &match_table?(&1, table_name)) |> Table.drop(ingredient)
  end

  def move_topping(nil, kitchen, _, _), do: {:error, kitchen}

  def move_topping(topping, kitchen, from, to) do
    Enum.find(kitchen.tables, &match_table?(&1, from))
      |> move_table_from(kitchen, to, topping)
  end

  defp move_table_from(nil, kitchen, _, _), do: {:error, kitchen}
  defp move_table_from(from_table, kitchen, to, topping) do
    Enum.find(kitchen.tables, &match_table?(&1, to))
      |> move_table_to(from_table, kitchen, topping)
  end

  defp move_table_to(nil, _, kitchen, _), do: {:error, kitchen}

  defp move_table_to(to_table, from_table, kitchen, topping) do
    Table.remove(from_table, topping)
      |> moved_table_from(to_table, kitchen, topping)
  end

  defp moved_table_from({:error, _}, _, kitchen, _), do: {:error, kitchen}

  defp moved_table_from({:ok, from_table}, to_table, kitchen, topping) do
    Table.drop(to_table, topping) |> dropped_in_table_to(from_table, kitchen)
  end

  defp dropped_in_table_to({:error, _}, _, kitchen), do: {:error, kitchen}

  defp dropped_in_table_to({:ok, to_table}, from_table, kitchen) do
    i_from = Enum.find_index(kitchen.tables, &match_table?(&1, from_table.id))
    kitchen = %Kitchen{kitchen | tables: List.replace_at(kitchen.tables, i_from, from_table) }
    i_to = Enum.find_index(kitchen.tables, &match_table?(&1, to_table.id))
    kitchen = %Kitchen{kitchen | tables: List.replace_at(kitchen.tables, i_to, to_table) }
    {:ok, kitchen}
  end

  def update_table(kitchen, table) do
    index = Enum.find_index(kitchen.tables, fn t -> Utils.string_matches?(t.id, table.id) end)
    if index do
      %Kitchen{kitchen | tables: List.replace_at(kitchen.tables, index, table) }
    else
      kitchen
    end
  end

  defp match_table?(table, table_name) do
    Utils.string_matches?(table.id, table_name)
  end
end
