defmodule PizzaKanbanGameWeb.Board.OrdersBoardWidget do

  use Surface.LiveComponent

  require Logger

  prop game, :struct, default: nil
  prop done, :boolean, default: false


  def render(assigns) do
    ~H"""
      <div class="place-items-center bx-4">
        <div class="grid grid-cols-2 gap-2 ">
          <div :for={{order <- filter_orders(@game, @done) }} class="w-5/6 bg-yellow-100 filter drop-shadow-lg m-2 p-2 transform {{rotation(order.id)}}">
            <h4 class="text-sm font-bold">
              <svg :if={{order.done }} xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              orden #{{order.id}}
            </h4>
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


  defp filter_orders(nil, _), do: []

  defp filter_orders(game, done) do
    orders = Enum.filter(game.orders, &(&1.done == done))
    Logger.info("FILTER ORDERS #{inspect(done)} -> #{length(orders)}")
    orders
  end


end
