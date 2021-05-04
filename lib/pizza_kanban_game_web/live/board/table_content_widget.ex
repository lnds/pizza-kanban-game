defmodule PizzaKanbanGameWeb.Board.TableContentWidget do
  use Surface.Component

  alias PizzaKanbanGame.Models.{Ingredient, Pizza}
  alias PizzaKanbanGameWeb.Board.{IngredientWidget, PizzaWidget}

  prop table, :struct, required: true


  def render(assigns) do
    ~H"""
      {{ render_content(assigns, assigns.table.content) }}
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
      <div></div>
    """
  end


end
