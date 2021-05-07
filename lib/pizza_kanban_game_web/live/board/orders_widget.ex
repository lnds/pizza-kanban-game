defmodule PizzaKanbanGameWeb.Board.OrdersWidget do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.{KitchenWidget, PlateWidget, OrdersBoardWidget}
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.Models.Order

  prop game, :struct, default: nil


  def render(assigns) do
    ~H"""
      <div class="bg-gray-400 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-b border-gray-400 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Ordenes
            </h3>
            <OrdersBoardWidget game={{@game}} />
            </div>
        </div>
      </div>
    """
  end


end
