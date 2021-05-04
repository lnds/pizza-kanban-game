defmodule PizzaKanbanGameWeb.Board.PizzaWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Board.IngredientWidget

  prop pizza, :struct, default: nil
  prop table, :string, default: ""

  def render(assigns) do
    ~H"""
    <IngredientWidget :for={{ingredient <- @pizza.ingredients}} ingredient={{ingredient}} table="{{@table}}" />
    """
  end

end
