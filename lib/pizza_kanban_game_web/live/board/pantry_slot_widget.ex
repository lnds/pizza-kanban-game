defmodule PizzaKanbanGameWeb.Board.PantrySlotWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Pizza.Topping

  prop slot, :struct, default: nil

  def render(assigns) do
    draggable = assigns.slot.quantity > 0

    ~H"""
      <div class="flex flex-col items-center">
        <div class="bg-white h-12 w-12 flex items-center justify-center text-black text-2xl font-semibold rounded-3xl mb-1 overflow-hidden">
          <Topping alt="{{@slot.ingredient.display_name}}" draggable="{{draggable}}" id="{{@slot.ingredient.id}}" image="{{@slot.ingredient.image}}" from="pantry" />
          <div class="z-auto absolute text-sm rounded-full bg-white" draggable="{{draggable}}" phx-hook="Topping" id="q-{{@slot.ingredient.id}}" data-topping="{{@slot.ingredient.id}}" >{{@slot.quantity}}</div>
        </div>
        <span class="text-white text-sm text-align-center">{{@slot.ingredient.display_name}} </span>
      </div>
      """
  end

end
