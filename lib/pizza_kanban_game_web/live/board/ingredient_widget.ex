defmodule PizzaKanbanGameWeb.Board.IngredientWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes

  prop ingredient, :struct, default: nil
  prop table, :string, default: ""

  def render(assigns) do
    ~H"""
    <img
      class="absolute top-0 left-0 z-auto "
      id="{{@ingredient.id}}-topping-{{@table}}"
      src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/#{@ingredient.image}") }}"
      data-topping="{{@ingredient.id}}"
      data-table="{{@table}}"
      data-from="{{@table}}"
      phx-value-name="{{@table}}"
      phx-hook="Topping">
    """
  end

end
