defmodule PizzaKanbanGame.Player do
  defstruct id: nil, name: nil
  alias PizzaKanbanGame.{Player, Utils}
  @type t() :: %__MODULE__{}

  @type new_user :: {String.t(), String.t()}
  @spec new([new_user]) :: [PizzaKanbanGame.Player.t()]
  def new(names) when is_list(names), do: Enum.map(names, &new/1)

  @spec new(new_user) :: PizzaKanbanGame.Player.t()
  def new({name}), do: %Player{id: Utils.id(), name: name}

  @spec new(binary(), binary()) :: PizzaKanbanGame.Player.t()
  def new(id, name), do: %Player{id: id, name: name}

end
