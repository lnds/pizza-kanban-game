defmodule PizzaKanbanGame.Models.Table do

  use StructAccess

  defstruct id: "",
            content: nil

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Table, Pizza, Ingredient}

  @spec new(String.t()) :: PizzaKanbanGame.Models.Table.t()
  def new(id),
    do: %Table {
      id: id
    }

  def drop(%Table{content: nil}=table, %Ingredient{kind: :crust}=crust) do
    {:ok, %Table{table| content: Pizza.new(crust)} }
  end

  def drop(%Table{content: nil}=table, ingredient) do
    {:ok, %Table{table| content: ingredient} }
  end

  def drop(%Table{content: %Pizza{ingredients: _}}=table, ingredient) do
    Pizza.add_ingredient(table.content, ingredient) |> dropped_in_pizza(table)
  end

  def drop(table, _), do: {:error, table}

  defp dropped_in_pizza({:error, _pizza}, table), do: {:error, table}

  defp dropped_in_pizza({:ok, pizza}, table) do
    {:ok, %Table{table| content: pizza} }
  end


end
