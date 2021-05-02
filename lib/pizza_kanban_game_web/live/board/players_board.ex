defmodule PizzaKanbanGameWeb.Board.PlayersBoard do
  use Surface.LiveComponent

  data players, :list, default: []

  def render(assigns) do
    ~H"""
      <div class="bg-blue-200 text-purple-lighter flex-none pb-6 md:block">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <div class="flex flex-col">
            <h3 class="text-gray-900 mb-1 font-bold text-xl text-gray-100">
              Jugadores
            </h3>
            <ul>
              <li :for={{player <- @players}}>
                {{ player.name }}
              </li>
            </ul>
          </div>
        </div>
      </div>
    """
  end
end
