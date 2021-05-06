defmodule PizzaKanbanGame.Models.Pizza do

  use StructAccess

  require Logger

  defstruct id: "",
            ingredients: [],
            cook_time: 0

  @type t() :: %__MODULE__{}


  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{Oven, Pizza, Ingredient}

  @spec new(Ingredient.t()) :: PizzaKanbanGame.Models.Pizza.t()
  def new(%Ingredient{kind: :crust}=ingredient),
    do: %Pizza {
      id: Utils.id(),
      ingredients: [ingredient],
    }

  def new(ingredient), do: ingredient

  def add_ingredient(pizza, ingredient) do
    if Enum.find(pizza.ingredients, fn i -> i.id == ingredient.id end) do
      {:error, pizza}
    else
      ingredients = Enum.sort([ingredient | pizza.ingredients], &(&1.order <= &2.order))
      {:ok, %Pizza{pizza | ingredients: ingredients} }
    end
  end

  def cook(pizza, seconds) do
    %Pizza{pizza| cook_time: seconds }
  end

  def is_burned(pizza), do: Oven.get_burning_state(pizza.cook_time) == :burned

  def is_raw(pizza), do: !Pizza.is_burned(pizza)


end
