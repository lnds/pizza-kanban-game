defmodule PizzaKanbanGameWeb.Board.TableWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGameWeb.Board.TableContentWidget
  require Logger


  prop game_id, :string, required: true
  prop table, :struct, default: nil


  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-8 px-8 max-w-sm mx-auto bg-white rounded-xl shadow-md space-y-2 sm:py-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">
        <div class="relative w-auto z-auto py-14 px-14 border m-1 p-1 mx-4" phx-hook="Crust" phx-value-name="{{@table.id}}" id="crust-{{@table.id}}" draggable="true">
            <TableContentWidget table={{@table}} />
        </div>
        <button
          :on-click="cook"
          class={{"invisible px-4 py-1 text-sm text-purple-600 font-semibold rounded-full border border-purple-200 hover:text-white hover:bg-purple-600 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-purple-600 focus:ring-offset-2"}}>
          Hornear
        </button>
      </div>
    """
  end

  def handle_event("cook", _, socket) do
    Logger.info("cook")
    {:noreply, socket}
  end

  def push_topping(table_id, topping) do
    send_update(__MODULE__, id: table_id, new_topping: topping)
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

  defp has_crust?([%{topping: "crust",}]), do: true

  defp has_crust?([%{topping: "crust",}|_]), do: true

  defp has_crust?(_), do: false

end
