defmodule PizzaKanbanGame.Models.PantrySlot do

  use StructAccess

  defstruct id: nil,
            ingredient: nil,
            quantity: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{PantrySlot, Ingredient}

  @spec new(Ingredient.t(), integer) :: PizzaKanbanGame.Models.PantrySlot.t()
  def new(ingredient, quantity),
    do: %PantrySlot {
      id: Utils.id(),
      ingredient: ingredient,
      quantity: quantity
    }

end
