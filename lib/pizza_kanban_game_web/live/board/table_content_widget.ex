defmodule PizzaKanbanGameWeb.Board.TableContentWidget do
  use Surface.LiveComponent

  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.Models.{Kitchen, Table, Ingredient, Pizza, Oven}
  alias PizzaKanbanGameWeb.Board.{KitchenWidget, IngredientWidget, PizzaWidget, OvenWidget}

  prop table, :struct, required: true
  prop game, :struct, default: nil
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


  defp after_content(assigns, %Pizza{id: _}=_pizza) do
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
    table = socket.assigns.table
    pizza = table.content
    put_pizza_in_oven(pizza, table, socket)
  end

  defp put_pizza_in_oven(nil, _, socket), do: {:noreply, socket}

  defp put_pizza_in_oven(%Ingredient{id: _}, _, socket), do: {:noreply, socket}

  defp put_pizza_in_oven(%Pizza{id: _}=pizza, table, socket) do
    game = socket.assigns.game
    Logger.info("PUT PIZZA IN OVEN table=#{inspect(table)}\n pizza=#{inspect(pizza)}\n oven=#{inspect(game.oven)}")
    Oven.put_pizza(game.oven, pizza) |> validate_pizza_in_oven(game, table, socket)
  end

  defp validate_pizza_in_oven({:ok, oven}, game, table, socket) do
    Logger.info("validate pizza in oven: #{inspect(oven)}")
    table = %Table{table | content: nil }
    game = %Game{game | kitchen: Kitchen.update_table(game.kitchen, table), oven: oven }
    OvenWidget.refresh(game)
    KitchenWidget.save(game)
    {:noreply, socket |> assign(:game, game) |> assign(:table, table)}
  end

  defp validate_pizza_in_oven({:error, _}, _, _, socket) do
    {:noreply, socket}
  end

end
