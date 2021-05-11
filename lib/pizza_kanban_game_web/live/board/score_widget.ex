defmodule PizzaKanbanGameWeb.Board.ScoreWidget do
  use Surface.Component

  prop game, :struct, default: nil
  alias PizzaKanbanGame.Game

  def render(assigns) do
    ~H"""
    <span :if={{@game}} class="inline-block text-sm px-4 py-2 leading-none border  text-black border-black  mt-4 lg:mt-0">
      Ganancia: $ {{ @game.score }}</span>
    """
  end

end
