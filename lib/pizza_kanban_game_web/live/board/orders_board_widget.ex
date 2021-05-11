defmodule PizzaKanbanGameWeb.Board.OrdersBoardWidget do

  use Surface.LiveComponent

  require Logger

  alias PizzaKanbanGame.Models.{Order, Oven}

  prop game, :struct, default: nil
  prop done, :boolean, default: false


  def render(assigns) do
    ~H"""
      <div class="place-items-center bx-4">
        <div class="grid grid-cols-2 gap-2 ">
          <div :for={{order <- filter_orders(@game, @done) }} class="w-11/12 bg-yellow-100 filter drop-shadow-lg m-2 p-2 transform {{rotation(order.id)}}">
            <h4 class="text-sm font-bold">
              {{display_badge(assigns, order)}}
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
    if last do
      "#{bases}, #{toppings} y #{last.display_name}"
    else
      "#{bases}"
    end
  end

  defp display_badge(assigns, %Order{done: true}=order) do
    case Oven.get_burning_state(order.cook_time) do
      :burned ->  ~H"""
          <span :if={{order.id > 0}}> #{{order.id}} no ok</span>
          <div class="flex  text-red-800 place-content-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z" />
            </svg>
          </div>
          <span class="text-red-800">quemada</span>
          """
      :heating -> ~H"""
          <span :if={{order.id > 0}}> #{{order.id}}: ok</span>
          <div class="flex place-content-center text-green-600">
            <svg  xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="text-green-800 text-align-center">entregada</div>

          """
      :cooking -> ~H"""
          <div class="flex flex-col place-content-center">
            <span :if={{order.id > 0}}> #{{order.id}} no ok</span>
            <div class="flex text-red-800 place-content-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="text-red-800 text-align-center">cruda</div>
          </div>
        """
      _ -> ~H"""
            <span :if={{order.id > 0}}> #{{order.id}}</span>
            <span :if={{order.id == 0}}>no solicitada </span>
            <div class="flex place-content-center text-red-800">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 " fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14H5.236a2 2 0 01-1.789-2.894l3.5-7A2 2 0 018.736 3h4.018a2 2 0 01.485.06l3.76.94m-7 10v5a2 2 0 002 2h.096c.5 0 .905-.405.905-.904 0-.715.211-1.413.608-2.008L17 13V4m-7 10h2m5-10h2a2 2 0 012 2v6a2 2 0 01-2 2h-2.5" />
            </svg>
          </div>
          """
    end
  end


  defp display_badge(assigns, order) do
    ~H"""
      <span :if={{order.id > 0}}> #{{order.id}}</span>
    """
  end

  defp rotation(i) do
    case rem(i, 6) - 3 do
      -3 -> "-rotate-3"
      -2 -> "-rotate-2"
      -1 -> "-rotate-1"
      0 -> "rotate-0"
      1 -> "rotate-1"
      2 -> "rotate-2"
      _ -> "-rotate-0"
    end
  end


  defp filter_orders(nil, _), do: []

  defp filter_orders(game, done), do: Enum.filter(game.orders, &(&1.done == done))


end
