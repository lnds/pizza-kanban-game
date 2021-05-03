defmodule PizzaKanbanGameWeb.Board.Pantry do
  use Surface.LiveComponent

  alias PizzaKanbanGameWeb.Pizza.Ingredient

  data ingredients, :list, default: [
    %{name: "pizza_crust", image: "pizza_crust.png", alt: "masa"},
    %{name: "sauce", image: "sauce.png", alt: "salsa"},
    %{name: "cheese", image: "cheese.png", alt: "queso"},
    %{name: "salami", image: "salami.png", alt: "salami"},
    %{name: "green_peppers", image: "green_peppers.png", alt: "pimentón"},
    %{name: "pepperoni", image: "pepperoni.png", alt: "pepperoni"},
    %{name: "tomatoes", image: "tomatoes.png", alt: "tomate"},
    %{name: "pinneapples", image: "pineapples.png", alt: "piña"},
    %{name: "anchovies", image: "anchovies.png", alt: "anchoas"},
  ]

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <div class="bg-gray-900 text-purple-lighter flex-none w-24 p-6  md:block overscroll-auto">
        <div class="cursor-pointer mb-4">
          <Ingredient :for={{ing <- @ingredients}} name={{ing.name}} image={{ing.image}} alt={{ing.alt}} />
        </div>

      </div>
    """
  end
end
