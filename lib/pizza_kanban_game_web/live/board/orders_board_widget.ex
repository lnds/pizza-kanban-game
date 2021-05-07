defmodule PizzaKanbanGameWeb.Board.OrdersBoardWidget do

  use Surface.LiveComponent

  require Logger
  alias PizzaKanbanGameWeb.Board.{KitchenWidget, PlateWidget}
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.Models.Order

  prop game, :struct, default: nil


  def render(assigns) do
    ~H"""
      <div class="grid grid-cols-2 gap-4">
        <div :for={{order <- @game.orders}} class="bg-yellow-100 filter drop-shadow-lg m-2 p-2 transform {{rotation()}}">
          <h4 class="text-sm font-bold">orden #{{order.id}} </h4>
          <ul class="text-xs">
            <li :for={{ {has, base} <- order.bases }}>
              <span>{{ display_base(has, base) }}</span>
            </li>
            <li :for.with_index={{ {topping, i} <- order.toppings }} >
              <span >{{ display_topping(topping, i, order.toppings) }}</span>
            </li>
          </ul>
        </div>
      </div>
    """
  end

  defp display_base(true, base), do: "con #{base.display_name},"
  defp display_base(_, base), do: "sin #{base.display_name},"

  defp display_topping(topping, index, toppings) do
    if index < length(toppings)-1 do
      "#{topping.display_name},"
    else
      "y #{topping.display_name}"
    end
  end

  defp rotation() do
      case Enum.random(-2..2) do
        -2 -> "-rotate-2"
        -1 -> "-rotate-1"
        0 -> "rotate-0"
        1 -> "rotate-1"
        2 -> "rotate-2"
      end
    end

end
