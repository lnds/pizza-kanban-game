defmodule PizzaKanbanGameWeb.Board.OvenWidget do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.PlateWidget

  prop game, :struct, default: nil
  data oven, :struct, default: nil
  data clock_color, :string, default: "text-blue-100"

  def render(assigns) do
    ~H"""
      <div class="bg-gray-800 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Horno  <span class={{ "mx-4", @clock_color,  "mx-4 px-2 border flat-right " }}>{{show_clock(@game.oven)}}</span>
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
        <div :if={{@oven}} class="flex flex-wrap justify-center gap-4">
            <PlateWidget  :for={{ plate <- @oven.plates }} plate={{plate}} />
        </div>
      </div>
    """
  end

  def refresh(game) do
    color = case game.oven.clock do
      clock when clock <= 30 -> "text-blue-100"
      clock when clock < 40 -> "text-red-400"
      _ -> "text-red-600"
    end
    send_update(__MODULE__, id: "oven", oven: game.oven, game: game, clock_color: color)
  end

  def show_clock(nil) do
    "00:00"
  end

  def show_clock(oven) do
    seconds = oven.clock
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

end
