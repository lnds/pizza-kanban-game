defmodule PizzaKanbanGameWeb.Board.PantrySlotWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Pizza.Topping
  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes

  prop slot, :struct, default: nil
  prop draggable, :boolean, default: true

  def render(assigns) do
    draggable = assigns.slot.quantity > 0
    ~H"""
      <div class="relative flex flex-col items-center">
        <div class=" bg-white h-12 w-12 flex items-center justify-center text-black text-2xl font-semibold rounded-3xl mb-1 overflow-hidden">
          <img src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/#{@slot.ingredient.image}") }}"
              title="{{@slot.quantity}}" draggable="{{@draggable}}"
              id="{{@slot.ingredient.id}}" phx-hook="Topping" class="z-auto w-full"
              data-topping="{{@slot.ingredient.id}}" data-from="pantry">
        </div>
        <div class="z-auto absolute top-0 right-0 text-xs bg-blue-600 w-4 text-center text-white rounded-full ">{{@slot.quantity}}</div>
        <span class="text-white text-sm text-align-center items-center">{{@slot.ingredient.display_name}} </span>
      </div>
      """
  end

end
