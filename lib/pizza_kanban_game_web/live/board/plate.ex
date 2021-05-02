defmodule PizzaKanbanGameWeb.Board.Plate do
  use Surface.Component

  require Logger

  prop toppings, :list, default: []

  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-8 px-8 max-w-sm mx-auto bg-gray-300  rounded-xl shadow-md space-y-2 sm:py-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">
        <div class="relative w-auto z-auto py-14 px-14  m-1 p-1 mx-4">
          <img :for={{ topping <- @toppings }}
            class="absolute top-0 left-0 z-auto "
            src="{{topping.image}}"/>
        </div>
      </div>
    """
  end


end
