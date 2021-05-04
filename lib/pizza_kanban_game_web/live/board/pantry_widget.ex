defmodule PizzaKanbanGameWeb.Board.PantryWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGameWeb.Board.PantrySlotWidget

  prop game_id, :string, default: ""
  data slots, :list, default: []

  require Logger

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <div class="bg-gray-900 text-purple-lighter flex-none w-24 p-6  md:block overscroll-auto">
        <div class="cursor-pointer mb-4">
          <PantrySlotWidget :for={{slot <- @slots}} id="{{slot.id}}" game_id="{{@game_id}}" slot={{slot}} draggable={{slot.quantity > 0}} />
        </div>

      </div>
    """
  end

  def refresh(pantry) do
    send_update(__MODULE__, id: "pantry", slots: pantry.slots)
  end


end
