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
    Oven.put_pizza(socket.assigns.toppings, socket.assigns.name)
    {:noreply, socket}
  end

  def update(%{new_topping: topping}, socket) do
    Logger.info("add topping #{inspect(topping)}!!")
    if topping.topping == "pizza_crust" do
      if length(socket.assigns.toppings) == 0 do
        socket = socket
              |> assign(:button_visible, "visible")
              |> assign(:toppings, socket.assigns.toppings ++ [topping])
        {:ok, socket}
      else
        {:ok, socket}
      end
    else
      if socket.assigns.button_visible == "visible" || length(socket.assigns.toppings) == 0 do
        socket = socket |> assign(:toppings, socket.assigns.toppings ++ [topping])
        {:ok, socket}
      else
        {:ok, socket}
      end
    end
  end

  def update(%{pop_topping: _}, socket) do
    socket = socket |> assign(:toppings, Enum.drop(socket.assigns.toppings, -1))
    {:ok, socket}
  end


  def update(assigns, socket) do
    if not assigns.created do
      Logger.info("NOT CREATED!!")
      {:ok, table} = GameStore.get(assigns.game_id) |> GameStore.get_table(assigns.name)
      if table != nil do
        Logger.info("GABLE = #{inspect(table)}")
        assigns = %{assigns| created: true} |> Map.put(:toppings, table)
        has_crust = Enum.find(table, fn(topping) -> topping.topping ==  "pizza_crust" end)
        if has_crust do
          assigns = assigns |> Map.put(:button_visible, "visible")
          {:ok, assign(socket, assigns)}
        else
          {:ok, assign(socket, assigns)}
        end
      else
        assigns = %{assigns| created: true}
        {:ok, assign(socket, assigns)}
      end
    end
  end

  def push_topping(table_id, topping) do
    send_update(__MODULE__, id: table_id, new_topping: topping)
  end

  def pop_topping(table_id) do
    send_update(__MODULE__, id: table_id, pop_topping: "")
  end

  def clear(table_id) do
    send_update(__MODULE__, id: table_id, toppings: [], button_visible: "invisible")
  end

  def set(table_id, toppings) do
    send_update(__MODULE__, id: table_id, toppings: toppings)
  end


end
