defmodule PizzaKanbanGameWeb.Board.PizzaWidget do
  use Surface.Component

  alias PizzaKanbanGame.Models.{Pizza, Oven}
  alias PizzaKanbanGameWeb.Board.IngredientWidget
  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes


  prop pizza, :struct, default: nil
  prop table, :string, default: ""

  def render(assigns) do
    ~H"""
    <div  class="{{get_class(@pizza, @table)}}">
      <IngredientWidget :for={{ingredient <- @pizza.ingredients}} ingredient={{ingredient}} table="{{@table}}" />
      <img :if={{Pizza.burned?(@pizza)}}
        class="absolute top-0 left-0 z-auto "
        src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/burn.png") }}" >
    </div>
    """
  end

  defp get_class(pizza, "") do
    case Oven.get_burning_state(pizza.cook_time) do
      :dropped -> ""
      :cooking -> "animate-pulse "
      :heating -> "animate-pulse filter saturate-200"
      _-> "animate-pulse"
    end
  end

  defp get_class(_, _), do: ""

end
