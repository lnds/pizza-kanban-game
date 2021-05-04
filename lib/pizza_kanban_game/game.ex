defmodule PizzaKanbanGame.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            kitchen: nil,
            pantry: nil,
            score: 0,
            pizzas: 0,
            quality: 0.0,
            plates: [],
            state: :not_started

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.{Game, Utils}
  alias PizzaKanbanGame.Models.{Kitchen, Pantry}

  @default_table_count 9

  @spec new(String.t(), PizzaKanbanGame.Player.t()) :: PizzaKanbanGame.Game.t()
  def new(name, player),
    do: %Game{
      id: Utils.id(),
      name: name,
      players: [player],
      pantry: Pantry.new(),
      kitchen: Kitchen.new(@default_table_count)
    }

  def new_with_id(id, name, player),
    do: %Game{
      id: id,
      name: name,
      players: [player],
      pantry: Pantry.new(),
      kitchen: Kitchen.new(@default_table_count)
    }



  def subscribe(topic) do
    Phoenix.PubSub.subscribe(PizzaKanbanGame.PubSub, topic)
  end

  def broadcast({:error, _reason} = error, _topic, _event, _data), do: error

  def broadcast({:ok, game}, topic, event, data) do
    Phoenix.PubSub.broadcast(PizzaKanbanGame.PubSub, topic, {event, game, data})
  end

end
