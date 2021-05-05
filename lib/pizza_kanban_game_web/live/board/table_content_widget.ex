defmodule PizzaKanbanGameWeb.Board.TableContentWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGame.Models.{Ingredient, Pizza}
  alias PizzaKanbanGameWeb.Board.{IngredientWidget, PizzaWidget}

  prop table, :struct, required: true

  require Logger

  def render(assigns) do
    ~H"""
    <div class="relative w-auto z-auto py-10 px-10 border m-1 p-1 mx-4" phx-hook="Crust" phx-value-name="{{@table.id}}" id="crust-{{@table.id}}" draggable="true">
    {{ render_content(assigns, assigns.table.content) }}
    </div>
    {{ after_content(assigns, assigns.table.content) }}

    """
  end

  defp render_content(assigns, %Ingredient{id: _}=ingredient) do
    ~H"""
      <IngredientWidget ingredient={{ingredient}} table="{{@table.id}}" />
    """
  end

  defp render_content(assigns, %Pizza{id: _}=pizza) do
    ~H"""
      <PizzaWidget pizza={{pizza}} table="{{@table.id}}"  />
      """
  end

  defp render_content(assigns, _) do
    ~H"""
    """
  end


  defp after_content(assigns, %Pizza{id: _}=pizza) do
    ~H"""
      <button
      :on-click="cook"
      class={{"visible px-4 py-1 text-sm text-purple-600 font-semibold rounded-full border border-purple-200
      hover:text-white hover:bg-purple-600 hover:border-transparent focus:outline-none focus:ring-1 focus:ring-purple-600 focus:ring-offset-1"}}>
      Hornear
      </button>
    """
  end

  defp after_content(assigns, _) do
    ~H"""
    """
  end


  def handle_event("cook", _, socket) do
    Logger.info("cook")
    {:noreply, socket}
  end
end
