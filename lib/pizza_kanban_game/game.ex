defmodule PizzaKanbanGame.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            score: 0,
            pizzas: 0,
            quality: 0.0,
            tables: [],
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

end
