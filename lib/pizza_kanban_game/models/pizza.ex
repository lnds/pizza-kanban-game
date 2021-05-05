defmodule PizzaKanbanGame.Models.Pizza do

  use StructAccess

  require Logger

  defstruct id: "",
            ingredients: [],
            cook_time: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{Pizza, Ingredient}

  @spec new(Ingredient.t()) :: PizzaKanbanGame.Models.Pizza.t()
  def new(%Ingredient{kind: :crust}=ingredient),
    do: %Pizza {
      id: Utils.id(),
      ingredients: [ingredient],
    }

  def new(_), do: nil

  def add_ingredient(pizza, ingredient) do
    if Enum.find(pizza.ingredients, fn i -> i.id == ingredient.id end) do
      {:error, pizza}
    else
      ingredients = Enum.sort([ingredient | pizza.ingredients], &(&1.order <= &2.order))
      {:ok, %Pizza{pizza | ingredients: ingredients} }
    end
  end
end
