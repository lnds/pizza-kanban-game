defmodule PizzaKanbanGame.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            kitchen: nil,
            pantry: nil,
            oven: nil,
            orders: []

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

  def verifiy_plates(game, plates) do
    pizzas = Enum.map(plates, fn plate -> plate.pizza end)
    new_orders = Order.check_done_orders(game.orders, pizzas)
    %Game{game | orders: new_orders}
  end

end
