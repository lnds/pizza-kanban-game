defmodule PizzaKanbanGame.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            score: 0,
            pizzas: 0,
            quality: 0.0,
            tables: %{},
            plates: [],
            state: :not_started

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.{Game, Utils}

  @spec new(String.t(), PizzaKanbanGame.Player.t()) :: PizzaKanbanGame.Game.t()
  def new(name, player),
    do: %Game{
      id: Utils.id(),
      name: name,
      players: [player]
    }

  def new_with_id(id, name, player),
    do: %Game{
      id: id,
      name: name,
      players: [player]
    }



  def subscribe(topic) do
    Phoenix.PubSub.subscribe(PizzaKanbanGame.PubSub, topic)
  end

  def broadcast({:error, _reason} = error, _topic, _event, _data), do: error

  def broadcast({:ok, game}, topic, event, data) do
    Phoenix.PubSub.broadcast(PizzaKanbanGame.PubSub, topic, {event, game, data})
  end

end
