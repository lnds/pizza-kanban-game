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

  def match_ingredients(pizza, ingredients) do
    i1 = Enum.map(pizza.ingredients, fn ing -> ing.order end) |>  Enum.sum()
    i2 = Enum.map(ingredients, fn ing -> ing.order end) |>  Enum.sum()
    i1 == i2
  end
  def cook(pizza, seconds) do
    %Pizza{pizza| cook_time: seconds }
  end

  @spec burned?(Pizza.t()) :: boolean
  def burned?(pizza), do: Oven.get_burning_state(pizza.cook_time) == :burned

  @spec raw?(PizzaKanbanGame.Models.Pizza.t()) :: boolean
  def raw?(pizza), do: !Pizza.burned?(pizza)


end
