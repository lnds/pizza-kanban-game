defmodule PizzaKanbanGameWeb.Board.Oven do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.Plate
  alias PizzaKanbanGameWeb.Board.Table

  @limit 2
  data pizzas, :list, default: []

  def render(assigns) do
    ~H"""
      <div class="bg-gray-800 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100">
              Horno
            </h3>
          </div>
        </div>
        <!-- end header -->
        <div class="bordar-gray-600 m-4 group flex flex-row gap-4 items-center">
          <button
            :on-click="cook"
            class={{ "px-4 py-1 text-sm text-white font-semibold rounded-full border border-purple-200 hover:text-white bg-red-800 hover:bg-red-600 hover:border-purple-200 focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
            encender
          </button>
          <button
            :on-click="cook"
            class={{ "px-4 py-1 text-sm text-white font-semibold rounded-full border border-purple-200 hover:text-white bg-blue-800 hover:bg-blue-600 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
            apagar
          </button>
        </div>
        <div class="flex flex-wrap justify-center gap-4">
            <Plate :for={{ pizza <- @pizzas }} toppings={{pizza}} />
        </div>
      </div>
    """
  end

  def update(%{new_pizza: pizza, table: table}, socket) do
    Logger.info("add pizza #{inspect(pizza)} table = #{inspect(table)}!!")
    if length(socket.assigns.pizzas) < @limit do
      socket = socket |> assign(:pizzas, socket.assigns.pizzas ++ [pizza])
      Table.clear(table)
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def put_pizza(toppings, from) do
    Logger.info("put pizza #{inspect(toppings)}, from #{inspect(from)}")
    send_update(__MODULE__, id: "oven", new_pizza: toppings, table: from)
  end
end
