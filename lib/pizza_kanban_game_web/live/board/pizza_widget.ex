defmodule PizzaKanbanGameWeb.Board.PizzaWidget do
  use Surface.Component

  alias PizzaKanbanGame.Models.Pizza
  alias PizzaKanbanGameWeb.Board.IngredientWidget
  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes


  prop pizza, :struct, default: nil
  prop table, :string, default: ""

  def render(assigns) do
    ~H"""
    <IngredientWidget :for={{ingredient <- @pizza.ingredients}} ingredient={{ingredient}} table="{{@table}}" />
    <img :if={{Pizza.burned?(@pizza)}}
      class="absolute top-0 left-0 z-auto "
      src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/burn.png") }}" >
    """
  end

end
