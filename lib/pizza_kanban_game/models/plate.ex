defmodule PizzaKanbanGame.Models.Plate do

  use StructAccess

  defstruct pizza: nil,
            time: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Plate, Pizza}

  @spec new(Pizza.t()) :: PizzaKanbanGame.Models.Plate.t()
  def new(pizza),
    do: %Plate {
      pizza: pizza
    }

  def cook(plate, seconds) do
    %Plate{plate| time: seconds, pizza: Pizza.cook(plate.pizza, seconds) }
  end

end
