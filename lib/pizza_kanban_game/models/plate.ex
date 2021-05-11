defmodule PizzaKanbanGame.Models.Plate do

  use StructAccess

  defstruct pizza: nil

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Plate, Pizza}

  @spec new(Pizza.t()) :: PizzaKanbanGame.Models.Plate.t()
  def new(pizza),
    do: %Plate {
      pizza: pizza
    }


  def cook(plate, elapsed) do
    %Plate{plate| pizza: Pizza.cook(plate.pizza, elapsed) }
  end

end
