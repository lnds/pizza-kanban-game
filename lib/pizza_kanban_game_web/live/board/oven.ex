defmodule PizzaKanbanGameWeb.Board.Oven do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.Plate

  data pizzas, :list, default: []
  data clock, :integer, default: 0
  data clock_color, :string, default: "text-blue-100"
  prop game_id, :string, default: ""

  def render(assigns) do
    ~H"""
      <div class="bg-gray-800 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Horno  <span class={{ "mx-4", @clock_color,  "mx-4 px-2 border flat-right " }}>{{show_clock(@clock)}}</span>
            </h3>
          </div>
        </div>
        <!-- end header -->
        <div class="bordar-gray-600 m-4 group flex flex-row gap-4 items-center">
          <button
            :on-click="start"
            class={{ "px-4 py-1 text-sm text-white font-semibold rounded-full border border-purple-200 hover:text-white bg-red-800 hover:bg-red-600 hover:border-purple-200 focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
            encender
          </button>
          <button
            :on-click="stop"
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

  def refresh(game) do
    pizzas = game.plates
    Logger.info("pizzas in oven = #{inspect(pizzas)}")
    send_update(__MODULE__, id: "oven", pizzas: pizzas)
  end

  def show_clock(seconds) do
    minutes = div(seconds, 60) |> Integer.to_string |> String.pad_leading(2, "0")
    seconds = rem(seconds, 60) |> Integer.to_string |> String.pad_leading(2, "0")
    "#{minutes}:#{seconds}"
  end

  def handle_event("start", _, socket) do
    send(self(), :oven_clock_start)
    {:noreply, socket}
  end

  def handle_event("stop", _, socket) do
    send(self(), :oven_clock_stop)
    {:noreply, socket}
  end

  def tick(seconds, continue) do
    if seconds < 0 do
      send_update(__MODULE__, id: "oven", clock: 0)
    else
      send_update(__MODULE__, id: "oven", clock: seconds)
    end
    if seconds <= 30 do
      send_update(__MODULE__, id: "oven", clock_color: "text-blue-100")
    else  if seconds > 30 && seconds < 40 do
      send_update(__MODULE__, id: "oven", clock_color: "text-red-400")
    else
      send_update(__MODULE__, id: "oven", clock_color: "text-red-600")
    end
  end
    if continue, do: :timer.send_after(1000, self(), :oven_tick)
  end

end
