defmodule PizzaKanbanGameWeb.Board.OvenWidget do
  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.{KitchenWidget, PlateWidget}
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.Models.{Oven, Plate, Pizza}

  prop game, :struct, default: nil
  data oven, :struct, default: nil
  data clock_color, :string, default: "text-blue-100"

  def render(assigns) do
    ~H"""
      <div class="bg-gray-800 text-purple-lighter flex-none w-64 pb-6 md:block">
        <div class="border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col max-w">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-row max-w">
              Horno
              <span class={{ "mx-4", @clock_color,  "mx-4 px-2 border flat-right " }}>{{show_clock(@oven)}}</span>
              <span  class="mx-4 bg-blue-600 rounded border-gray-500" :if={{@oven}}>&nbsp;{{@oven.limit}}&nbsp;</span>
            </h3>
            <div class="border-gray-600 m-4 grid place-items-center">
              <button :if={{@oven && !@oven.on}}
                :on-click="start"
                class={{ "align-center px-4 py-1 text-sm text-white font-semibold rounded-full border border-purple-200 hover:text-white bg-red-800 hover:bg-red-600 hover:border-purple-200 focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
                encender
              </button>
              <button :if={{@oven && @oven.on}}
                :on-click="stop"
                class={{ "px-4 py-1 text-sm text-white font-semibold rounded-full border border-purple-200 hover:text-white bg-blue-800 hover:bg-blue-600 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
                apagar
              </button>
            </div>
          </div>
        </div>
        <!-- end header -->

        <div :if={{@oven}} class="flex flex-wrap justify-center gap-4">
            <PlateWidget  :for={{ plate <- @oven.plates }} plate={{plate}} />
        </div>
      </div>
    """
  end

  def refresh(game) do
    state = Oven.get_burning_state(game.oven.clock)
    color = case state do
      :cooking -> "text-blue-100"
      :heating -> "text-red-400"
      _ -> "text-red-600"
    end
    plates = Enum.map(game.oven.plates, &Plate.cook(&1, game.oven.clock))
    oven = %Oven{game.oven| plates: plates}
    game = %Game{game | oven: oven}
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
