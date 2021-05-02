defmodule PizzaKanbanGameWeb.Board.Kitchen do

  use Surface.LiveComponent

  alias PizzaKanbanGameWeb.PizzaGameLive
  alias PizzaKanbanGameWeb.Board.Table

  require Logger


  data pizzas, :integer, default: 0
  data ingredients, :integer, default: 0

  def mount(socket) do
    if connected?(socket), do: PizzaGameLive.subscribe()
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div id="kitchen" class="flex-1 flex flex-col bg-gray-700 overflow-hidden">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-inline">
              Cocina
              <span class="mx-4 flex flex-inline w-max mb-2 font-normal text-base">
                <ul class="ml-auto flex justify-items-center">
                <li class="flex-col mx-2">Pizzas: {{ @pizzas }}</li>
                <li class="flex-col mx-2">Ingredients: {{ @ingredients }}</li>
                </ul>
              </span>
            </h3>
          </div>
          <!-- end header -->
        </div>
        <div class="flex flex-wrap justify-center gap-4">
            <Table :for={{ table <- 1..9}} id="table-{{table}}" name="table-{{table}}" />
        </div>
      </div>
    """
  end


  def handle_event("drop", %{"topping" => topping, "image" => image, "to" => table}, socket) do
    Logger.info("drop #{topping} to table #{table}")
    PizzaGameLive.broadcast(:drop_topping, %{topping: topping, image: image}, table)
    {:noreply, socket }
  end

  def handle_event("pop", %{"from" => table}, socket) do
    Logger.info("pop #{inspect(table)}")
    Table.pop_topping(table)
    {:noreply, socket}
  end



end
