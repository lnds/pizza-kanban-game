defmodule PizzaKanbanGameWeb.Pizza.Topping do
  use Surface.Component

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes

  prop id, :string, required: false
  prop image, :string, required: false
  prop alt, :string, required: false, default: ""
  prop draggable, :boolean, required: false, default: true


  def render(assigns) do
    ~H"""
        <img src="{{ Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/#{@image}") }}"
              alt="{{@alt}}" draggable="{{@draggable}}"
              id="{{@id}}" phx-hook="Topping" class="z-auto w-full" data-topping="{{@id}}">
      """
  end
end
