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


  def pop_topping(%Table{content: %Ingredient{id: _}}=table) do
    {:ok, %Table{table| content: nil}}
  end

  def pop_topping(%Table{content: %Pizza{ingredients: ingredients}}=table) do
    new_ingredients = Enum.drop(ingredients, -1)
    if length(new_ingredients) == 0 do
      {:ok, %Table{table| content: nil}}
    else
      {:ok, %Table{table| content: %Pizza{table.content| ingredients: new_ingredients}}}
    end
  end

end
