defmodule PizzaKanbanGame.Models.Kitchen do

  use StructAccess


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
    Enum.find(kitchen.tables, fn table -> Utils.string_matches?(table.id, table_name) end) |> Table.drop(ingredient)
  end

  def move_topping(kitchen, _topping, _from, _to) do
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
end
