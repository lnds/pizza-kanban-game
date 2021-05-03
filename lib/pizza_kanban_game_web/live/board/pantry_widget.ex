defmodule PizzaKanbanGameWeb.Board.PantryWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGame.PantryStore
  alias PizzaKanbanGameWeb.Board.PantrySlotWidget

  prop game_id, :string, default: ""
  data slots, :list, default: []

  require Logger

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <div class="bg-gray-900 text-purple-lighter flex-none w-24 p-6  md:block overscroll-auto">
        <div class="cursor-pointer mb-4">
          <PantrySlotWidget :for={{slot <- @slots}} slot={{slot}} draggable={{slot.quantity > 0}} />
        </div>

      </div>
    """
  end

  def refresh(game) do
    {:ok, pantry} = PantryStore.find_game_pantry(game.id)
    send_update(__MODULE__, id: "pantry", slots: pantry.slots)
  end

  def remove_ingredient(game_id, topping) do
    Logger.info("remove ingredient <- #{inspect(topping)}")

    {result, pantry} = PantryStore.find_game_pantry(game_id) |> PantryStore.remove_ingredient(topping)
    if result == :ok do
      Logger.info("remove ingredient #{inspect(pantry)}")
      send_update(__MODULE__, id: "pantry", slots: pantry.slots)
      true
    else
      false
    end
  end
end
