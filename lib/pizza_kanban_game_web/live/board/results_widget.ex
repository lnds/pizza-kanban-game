defmodule PizzaKanbanGameWeb.Board.ResultsWidget do
  use Surface.LiveComponent

  require Logger

  prop game, :struct, default: nil

  def render(assigns) do
    ~H"""
      <div class="bg-gray-600 text-purple-lighter flex-none w-2/12 pb-6 md:block">
        <div class="flex px-6 py-2 items-center flex-none">
          <!-- header -->
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Resultados
            </h3>
          </div>
          <!-- end header -->
        </div>
      </div>
    """
  end


end
