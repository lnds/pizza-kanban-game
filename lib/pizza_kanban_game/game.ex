defmodule PizzaKanbanGame.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            kitchen: nil,
            pantry: nil,
            oven: nil,
            orders: [],
            score: 0,
            clock: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.{Game, Utils}
  alias PizzaKanbanGame.Models.{Kitchen, Pantry, Oven, Order}

  @default_table_count 9
  @default_oven_slots 2
  @default_order_quantity 20

  require Logger

  @spec new(String.t(), PizzaKanbanGame.Player.t()) :: PizzaKanbanGame.Game.t()
  def new(name, player), do: new_with_id(Utils.id(), name, player)

  def new_with_id(id, name, player),
    do: %Game{
      id: id,
      name: name,
      players: [player],
      pantry: Pantry.new(),
      kitchen: Kitchen.new(@default_table_count),
      oven: Oven.new(@default_oven_slots),
      orders: Order.gen_random_orders(@default_order_quantity)
    }



  def subscribe(topic) do
    Phoenix.PubSub.subscribe(PizzaKanbanGame.PubSub, topic)
  end

  def broadcast({:error, _reason} = error, _topic, _event, _data), do: error

  def broadcast({:ok, game}, topic, event, data) do
    Phoenix.PubSub.broadcast(PizzaKanbanGame.PubSub, topic, {event, game, data})
    {:ok}
  end

  @spec verifiy_plates(PizzaKanbanGame.Game.t(), any) :: PizzaKanbanGame.Game.t()
  def verifiy_plates(game, plates) do
    pizzas = Enum.map(plates, fn plate -> plate.pizza end)
    {new_orders, left_pizzas} = Order.check_done_orders(game.orders, pizzas)
    unsolicited = Enum.map(left_pizzas, fn pizza -> Order.unsolicited_from_pizza(pizza) end)
    %Game{game | orders: new_orders ++ unsolicited}
  end

  def score(nil), do: 0

  def score(game) do
    orders_sum = Enum.map(game.orders, fn order -> Order.value(order) end) |> Enum.sum()
    pantry_sum = Pantry.inventory(game.pantry)
    Logger.info("orders_sum = #{inspect(orders_sum)}")
    Logger.info("pantry_sum = #{inspect(pantry_sum)}")
    orders_sum - pantry_sum
  end

end
