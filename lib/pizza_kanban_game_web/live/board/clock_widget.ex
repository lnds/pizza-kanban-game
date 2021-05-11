defmodule PizzaKanbanGameWeb.Board.ClockWidget do
  use Surface.LiveComponent

  prop game, :struct, default: nil

  require Logger

  def render(assigns) do
    ~H"""
    <div>
      <button :if={{@game && @game.clock == 0}}
      class="inline-block text-sm px-4 py-2 font-semibold leading-none rounded-full border border-purple-200 hover:text-white bg-blue-800 hover:bg-blue-600 hover:border-transparente focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2 text-white "
      :on-click="start-round">
      Empezar Round
      </button>
      <span :if={{@game && @game.clock > 0}}class="inline-block text-sm px-4 py-2 leading-none border  text-black border-black  mt-4 lg:mt-0">{{show_clock(@game)}}</span>
    </div>
    """
  end

  def handle_event("start-round", _, socket) do
    send(self(), :game_start_round)
    Logger.info("start round")
    {:noreply, socket}
  end

  defp show_clock(nil) do
    "00:00"
  end

  defp show_clock(game) do
    seconds = game.clock
    minutes = div(seconds, 60) |> Integer.to_string |> String.pad_leading(2, "0")
    seconds = rem(seconds, 60) |> Integer.to_string |> String.pad_leading(2, "0")
    "#{minutes}:#{seconds}"
  end

end
