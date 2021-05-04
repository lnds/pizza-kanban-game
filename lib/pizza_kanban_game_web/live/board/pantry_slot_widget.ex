defmodule PizzaKanbanGameWeb.Board.PantrySlotWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGame.{Game, GameStore}
  alias PizzaKanbanGame.Models.{Pantry, PantrySlot}
  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.Kitchen

  require Logger

  prop slot, :struct, default: nil
  prop draggable, :boolean, default: true
  prop game_id, :string, default: ""

  def render(assigns) do
    ~H"""
      <div class="relative flex flex-col items-center">
        <div class=" bg-white h-12 w-12 flex items-center justify-center text-black text-2xl font-semibold rounded-3xl mb-1 overflow-hidden">
          <img src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/#{@slot.ingredient.image}") }}"
              title="{{@slot.quantity}}" draggable="{{@draggable}}"
              id="{{@slot.ingredient.id}}" phx-hook="Topping" class="z-auto w-full"
              data-topping="{{@slot.ingredient.id}}" data-from="pantry">
        </div>
        <div class="z-auto absolute -top-1 -left-2 text-xs bg-blue-600 w-4 text-center text-white rounded-full ">
          {{@slot.quantity}}
        </div>
        <div class="z-auto absolute -top-1 -right-2 text-xs bg-red-600 w-4 text-center text-white rounded-full "
              :on-click="inc">
          +
        </div>
        <span class="text-white relative -top-1 text-sm text-align-center items-center">{{@slot.ingredient.display_name}} </span>
      </div>
      """
  end

  def handle_event("inc", _, socket) do
    Logger.info("INC")
    game_id = socket.assigns.game_id
    GameStore.get(game_id) |> inc_slot(socket)
  end

  defp inc_slot({:ok, game}, socket) do
    slot = %PantrySlot{socket.assigns.slot | quantity: socket.assigns.slot.quantity + 1}
    Pantry.replace_slot(game.pantry, slot) |> slot_replaced(game, slot, socket)
  end

  defp inc_slot(_, socket), do: {:noreply, socket}

  defp slot_replaced({:ok, pantry}, game, slot, socket) do
    game = %Game{game | pantry: pantry}
    GameStore.save(game) |> update_slot(slot, socket)
  end

  defp slot_replaced(_, _, _, socket), do: {:noreply, socket}

  defp update_slot({:ok, game}, slot, socket) do
    send_update(__MODULE__, id: socket.assigns.id, slot: slot)
    Kitchen.broad_cast(game, :update_pantry)
    {:noreply, socket}
  end

end
