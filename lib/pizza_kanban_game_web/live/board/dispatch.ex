defmodule PizzaKanbanGameWeb.Board.Dispatch do
  use Surface.Component


  def render(assigns) do
    ~H"""
      <div class="bg-blue-400 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <div class="flex flex-col">
            <h3 class="text-gray-900 mb-1 font-bold text-xl text-gray-100">
              Despacho
            </h3>
          </div>
        </div>
      </div>
    """
  end
end
