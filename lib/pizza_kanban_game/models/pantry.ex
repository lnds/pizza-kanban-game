defmodule PizzaKanbanGame.Models.Pantry do

  use StructAccess

  defstruct id: nil,
            game_id: nil,
            slots: []

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{Pantry, PantrySlot, Ingredient}

  @crust %Ingredient{id: "crust", display_name: "masa", image: "pizza_crust.png", cost: 100, order: 0, kind: :crust}
  @sauce %Ingredient{id: "sauce", display_name: "salsa", image: "sauce.png", cost: 50, order: 1, kind: :base}
  @cheese %Ingredient{id: "cheese", display_name: "queso", image: "cheese.png", cost: 50, order: 2, kind: :base}
  @salami %Ingredient{id: "salami", display_name: "salami", image: "salami.png", cost: 20, order: 4, kind: :topping}
  @pepperoni %Ingredient{id: "pepperoni", display_name: "pepperoni", image: "pepperoni.png", cost: 20, order: 8, kind: :topping}
  @tomato %Ingredient{id: "tomato", display_name: "tomate", image: "tomatoes.png", cost: 10, order: 16, kind: :topping}
  @green_peppers %Ingredient{id: "green_peppers", display_name: "pimentón", image: "green_peppers.png", cost: 10, order: 32, kind: :topping}
  @pineapple %Ingredient{id: "pineapple", display_name: "piña", image: "pineapples.png", cost: 15, order: 64, kind: :topping}
  @anchovies %Ingredient{id: "anchovies", display_name: "anchoas", image: "anchovies.png", cost: 15, order: 128, kind: :topping}



  @default_quantity 10

  @spec new(String.t()) :: PizzaKanbanGame.Models.Pantry.t()
  def new(game_id),
    do: %Pantry {
      id: Utils.id(),
      game_id: game_id,
      slots: [
        PantrySlot.new(@crust, @default_quantity),
        PantrySlot.new(@sauce, @default_quantity),
        PantrySlot.new(@cheese, @default_quantity),
        PantrySlot.new(@salami, @default_quantity),
        PantrySlot.new(@pepperoni, @default_quantity),
        PantrySlot.new(@tomato, @default_quantity),
        PantrySlot.new(@green_peppers, @default_quantity),
        PantrySlot.new(@pineapple, @default_quantity),
        PantrySlot.new(@anchovies, @default_quantity),
      ]
    }

end
