defmodule PizzaKanbanGameWeb.Board.PlateWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Board.PizzaWidget
  alias PizzaKanbanGame.Models.Pizza
  require Logger

  prop plate, :struct, default: []

  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-8 px-8 max-w-sm mx-auto bg-gray-300  rounded-xl shadow-md space-y-2 sm:py-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">
        <div class="relative w-auto z-auto py-14 px-14  m-1 p-1 mx-4 ">
          <PizzaWidget pizza={{@plate.pizza}} />
        </div>
      </div>
    """
  end


end
