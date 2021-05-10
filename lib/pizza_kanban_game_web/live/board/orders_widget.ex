defmodule PizzaKanbanGameWeb.Board.OrdersWidget do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.OrdersBoardWidget

  prop game, :struct, default: nil

  def render(assigns) do
    ~H"""
      <div class="bg-gray-400 text-purple-lighter flex-none w-2/12 pb-3 md:block">
        <div class="border-b border-gray-400 flex px-1 py-2 items-center flex-none">
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Ordenes
            </h3>
            <OrdersBoardWidget id="orders_wdiget" game={{@game}} done={{false}} />
            </div>
        </div>
      </div>
    """
  end

  def refresh(game) do
    send_update(__MODULE__, id: "orders", game: game)
  end


end
