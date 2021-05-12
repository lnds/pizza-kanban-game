defmodule PizzaKanbanGame.Models.Order do

  use StructAccess

  require Logger

  defstruct id: 0,
            cook_time: 0,
            done: false,
            bases: [],
            toppings: []

  @type t() :: %__MODULE__{}

  @topping_limit 4

  alias PizzaKanbanGame.Models.{Order, Pantry, Pizza, Oven}

  @spec new(integer) :: PizzaKanbanGame.Models.Order.t()
  def new(id),
    do: %Order {
      id: id,
      bases: Pantry.get_ingredients(:base) |> Enum.map(&({toss_coin(), &1})),
      toppings:  Pantry.get_ingredients(:topping)
                      |> Enum.filter(fn _ -> toss_coin() end)
                      |> Enum.take(@topping_limit)
    }

  def value(%Order{done: true}=order) do
    crust = Pantry.get_crust()
    bases_cost = filter_bases(order.bases)  |> Enum.map(fn base ->  base.cost end) |> Enum.sum()
    toppings_cost = Enum.map(order.toppings, fn base -> base.cost end) |> Enum.sum()

    value = case Oven.get_burning_state(order.cook_time) do
      :heating when order.id > 0 -> crust.cost + bases_cost + toppings_cost
      :heating when order.id <= 0 -> -(crust.cost + bases_cost + toppings_cost)
      _ ->  - (crust.cost + bases_cost + toppings_cost)
    end
    Logger.info("value of order = #{inspect(order)}")
    Logger.info("is = #{inspect(value)}")
    Logger.info("burningstate = #{inspect(Oven.get_burning_state(order.cook_time) )}")
    value
  end

  def value(_), do: 0



  @spec unsolicited_from_pizza(Pizza.t()) :: PizzaKanbanGame.Models.Order.t()
  def unsolicited_from_pizza(pizza),
    do: %Order {
      id: -1,
      bases: Enum.filter(pizza.ingredients, &(&1.kind == :base)) |> Enum.map(&({true, &1})),
      toppings: Enum.filter(pizza.ingredients, &(&1.kind == :topping)),
      done: true,
      cook_time: pizza.cook_time
    }

  defp toss_coin() do
    Enum.random([false, true])
  end

  def gen_random_orders(limit, base \\ 0) do
    n = Enum.random(5..limit)
    Enum.map(1 .. n, fn i -> Order.new(base + i) end)
  end

  def check_done_orders(orders, pizzas), do: check_pizzas(orders, pizzas)

  defp check_pizzas([], pizzas), do: {[], pizzas}

  defp check_pizzas([order], pizzas) do
    if pizza = Enum.find(pizzas, fn pizza -> Pizza.match_ingredients(pizza, filter_bases(order.bases) ++ order.toppings) end) do
      { [%Order{order| done: true, cook_time: pizza.cook_time}], pizzas -- [pizza] }
    else
      { [order], pizzas }
    end
  end

  defp check_pizzas([head|tail], pizzas) do
    {new_head, pizzas} = check_pizzas([head], pizzas)
    {new_tail, pizzas} = check_pizzas(tail, pizzas)
    {new_head ++ new_tail, pizzas}
  end

  defp filter_bases(bases) do
    Enum.filter(bases, fn {m, _} -> m end) |> Enum.map(fn {_, ing} -> ing end)
  end


end
