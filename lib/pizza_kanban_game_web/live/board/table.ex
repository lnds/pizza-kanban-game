defmodule PizzaKanbanGameWeb.Board.Table do
  use Surface.LiveComponent

  require Logger

  alias PizzaKanbanGameWeb.Board.Oven
  alias PizzaKanbanGameWeb.GameStore

  prop name, :string, required: true
  prop game_id, :string, required: true
  data toppings, :list, default: []
  data button_visible, :string, default: "invisible"
  prop created, :boolean, default: false


  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-8 px-8 max-w-sm mx-auto bg-white rounded-xl shadow-md space-y-2 sm:py-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">
        <div class="relative w-auto z-auto py-14 px-14 border m-1 p-1 mx-4" phx-hook="Crust" phx-value-name="{{@name}}"
            id="crust-{{@name}}" draggable="true">
          <img :for.with_index={{ {topping, i} <- @toppings }}
            class="absolute top-0 left-0 z-auto "
            id="{{@name}}-topping-{{i}}"
            src="{{topping.image}}"
              data-topping="{{topping.topping}}"
              data-table="{{@name}}"
              phx-value-name="{{@name}}"
              phx-hook="Topping">
        </div>
        <button
          :on-click="cook"
          class={{@button_visible, "px-4 py-1 text-sm text-purple-600 font-semibold rounded-full border border-purple-200 hover:text-white hover:bg-purple-600 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
          Hornear
        </button>
      </div>
    """
  end

  def handle_event("cook", _, socket) do
    Logger.info("cook")
    game_id = get_game_id(socket)
    table = socket.assigns.id
    {:ok, game} = GameStore.get(game_id)
      |> GameStore.clear_table(table)
    refresh(game, table)
    {:noreply, socket}
  end

  def push_topping(table_id, topping) do
    send_update(__MODULE__, id: table_id, new_topping: topping)
  end

  def clear(table_id) do
    GameStore
    send_update(__MODULE__, id: table_id, toppings: [], button_visible: "invisible")
  end

  def set(table_id, toppings) do
    send_update(__MODULE__, id: table_id, toppings: toppings)
  end

  def refresh(game, table_id) do
    table = game.tables[table_id]
    send_update(__MODULE__, id: table_id, toppings: table)
    if has_crust?(table) do
      send_update(__MODULE__, id: table_id, button_visible: "visible")
    else
      send_update(__MODULE__, id: table_id, button_visible: "invisible")
    end
  end


  defp get_game_id(socket) do
    socket.assigns.game_id
  end

  defp has_crust?(nil), do: false

  defp has_crust?([%{topping: "pizza_crust",}]), do: true

  defp has_crust?([%{topping: "pizza_crust",}|_]), do: true

  defp has_crust?(_), do: false

end
