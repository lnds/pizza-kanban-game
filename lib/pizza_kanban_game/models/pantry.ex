defmodule PizzaKanbanGame.Models.Pantry do

  use StructAccess

  defstruct id: nil,
            slots: []

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Utils
  alias PizzaKanbanGame.Models.{Pantry, PantrySlot, Ingredient}

  require Logger

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

  @default_ingredients  [
    @crust,
    @sauce,
    @cheese,
    @salami,
    @pepperoni,
    @tomato,
    @green_peppers,
    @pineapple,
    @anchovies,
  ]

  @default_slots  Enum.map(@default_ingredients, &PantrySlot.new(&1, @default_quantity))



  @spec new :: PizzaKanbanGame.Models.Pantry.t()
  def new(),
    do: %Pantry {
      id: "pantry",
      slots: @default_slots
    }

  def get_ingredient_by_id(pantry, id) do
    slot = Enum.find(pantry.slots, fn s -> Utils.string_equals?(s.ingredient.id, id) end)
    if slot do
      slot.ingredient
    else
      nil
    end
  end

  def get_ingredients(kind) do
    Enum.filter(@default_ingredients, &(&1.kind == kind))
  end

  def replace_slot(pantry, new_slot) do
    get_and_update_in(pantry.slots,
      [Access.filter(fn slot -> Utils.string_equals?(slot.id, new_slot.id) end)],
      fn slot -> {slot, new_slot} end
    ) |> validate_slot_change(pantry)
  end

  @spec remove_ingredient(Pantry.t(), String.t()) :: {:error, :empty_slot, nil} | {:ok, Pantry.t(), PantrySlot.t()}
  def remove_ingredient(pantry, ing) do
    add_ingredient(pantry, ing, -1)
  end

  def add_ingredient(pantry, ing), do: add_ingredient(pantry, ing, 1)

  def add_ingredient(pantry, ing, q) do
    get_and_update_in(pantry.slots,
      [Access.filter(fn slot -> Utils.string_equals?(slot.ingredient.id, ing) end)],
      fn slot -> {slot, %PantrySlot{slot| quantity: slot.quantity+q}} end
    ) |> validate_slot_change(pantry)
  end


  defp validate_slot_change({[changed_slot|_], slots}, pantry) when changed_slot.quantity > 0 do
    {:ok,  %Pantry{pantry | slots: slots}, changed_slot}
  end

  defp validate_slot_change(_, _), do: {:error, :empty_slot, nil}


end
