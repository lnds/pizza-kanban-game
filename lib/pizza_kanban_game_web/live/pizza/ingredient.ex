defmodule PizzaKanbanGameWeb.Pizza.Ingredient do
  use Surface.Component

  alias PizzaKanbanGameWeb.Pizza.Topping

  prop alt, :string, required: false
  prop name, :string, required: true
  prop image, :string, required: true

  def render(assigns) do
    ~H"""
      <div class="">
        <div class="bg-white h-12 w-12 flex items-center justify-center text-black text-2xl font-semibold rounded-3xl mb-1 overflow-hidden">
          <Topping alt="{{@alt}}" draggable="true" id="{{@name}}" image="{{@image}}" />
          </div>
          <span class="text-white text-sm text-align-center">{{@alt}}</span>
      </div>
      """
  end
end
