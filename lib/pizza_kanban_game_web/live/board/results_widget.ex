defmodule PizzaKanbanGameWeb.Board.ResultsWidget do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.OrdersBoardWidget

  prop game, :struct, default: nil

  def render(assigns) do
    ~H"""
      <div class="bg-gray-600 text-purple-lighter flex-none w-2/12 pb-3 md:block">
        <div class="flex px-1 py-2 items-center flex-none">
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Resultados
            </h3>
            <OrdersBoardWidget id="results_board" game={{@game}} done={{true}} />
          </div>
        </div>
      </div>
    """
  end

  def refresh(game) do
    send_update(__MODULE__, id: "results", game: game)
  end


end
