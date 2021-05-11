defmodule PizzaKanbanGameWeb.Board.PlateWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Board.PizzaWidget
  require Logger

  prop plate, :struct, default: []

  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-2 px-2 max-w-sm mx-auto bg-gray-300 rounded-xl shadow-md space-y-1 sm:py-2 sm:flex sm:items-center sm:space-y-0 sm:space-x-2">
        <div class="relative w-auto z-auto py-14 px-14  m-1 p-1 mx-2 ">
          <PizzaWidget pizza={{@plate.pizza}} />
        </div>
        <div class="text-red-400">
          <span>|{{@plate.pizza.cook_time}}|</span>
        </div>
      </div>
    """
  end


end
