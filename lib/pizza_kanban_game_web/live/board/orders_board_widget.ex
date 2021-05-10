defmodule PizzaKanbanGameWeb.Board.OrdersBoardWidget do

  use Surface.LiveComponent

  require Logger

  prop game, :struct, default: nil


  def render(assigns) do
    ~H"""
      <div class="place-items-center bx-4">
        <div class="grid grid-cols-2 gap-2 ">
          <div :for={{order <- @game.orders}} class="w-20 bg-yellow-100 filter drop-shadow-lg m-2 p-2 transform {{rotation(order.id)}}">
            <h4 class="text-sm font-bold">orden #{{order.id}} </h4>
            <p class="text-xs" :if={{order && order.bases && order.toppings}}>
              {{ display_ingredients(order.bases, order.toppings)}}
            </p>
          </div>
        </div>
      </div>
    """
  end

  defp display_base(true, base), do: "con #{base.display_name}"
  defp display_base(_, base), do: "sin #{base.display_name}"

  defp display_ingredients(bases, toppings) do
    bases = Enum.map(bases, fn {show, base} -> display_base(show, base) end)
        |> Enum.join(", ")
    last = List.last(toppings)
    toppings = List.delete_at(toppings, -1)
        |> Enum.map(fn topping -> topping.display_name end)
        |> Enum.join(", ")
    "#{bases}, #{toppings} y #{last.display_name}"
  end

  defp rotation(i) do
      case rem(i, 6) - 3 do
        -2 -> "-rotate-2"
        -1 -> "-rotate-1"
        1 -> "rotate-1"
        2 -> "rotate-2"
        _ -> "rotate-0"
      end
    end

end
