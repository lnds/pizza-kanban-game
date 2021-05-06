defmodule PizzaKanbanGame.Models.Order do

  use StructAccess

  require Logger

  defstruct id: 0,
            bases: [],
            toppings: []

  @type t() :: %__MODULE__{}

  @topping_limit 4

  alias PizzaKanbanGame.Models.{Order, Pantry}

  @spec new(integer) :: PizzaKanbanGame.Models.Order.t()
  def new(id),
    do: %Order {
      id: id,
      bases: Pantry.get_ingredients(:base) |> Enum.map(&({toss_coin(), %{id: &1.id, display_name: &1.display_name}})),
      toppings:  Pantry.get_ingredients(:topping)
                      |> Enum.filter(fn _ -> toss_coin() end)
                      |> Enum.map( &( %{id: &1.id, display_name: &1.display_name} ) )
                      |> Enum.take(@topping_limit)
    }


  defp toss_coin() do
    Enum.random([false, true])
  end



  def gen_random_orders(limit, base \\ 0) do
    n = Enum.random(5..limit)
    Enum.map(1 .. n, fn i -> Order.new(base + i) end)
  end

end
