defmodule PizzaKanbanGame.Models.Plate do

  use StructAccess

  defstruct pizza: nil,
            time: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Plate, Plate}

  @spec new(Pizza.t()) :: PizzaKanbanGame.Models.Plate.t()
  def new(pizza),
    do: %Plate {
      pizza: pizza
    }


end
