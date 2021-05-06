defmodule PizzaKanbanGame.Models.Plate do

  use StructAccess

  defstruct pizza: nil,
            start_time: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Plate, Pizza}

  @spec new(Pizza.t(), integer) :: PizzaKanbanGame.Models.Plate.t()
  def new(pizza, start_time),
    do: %Plate {
      pizza: pizza,
      start_time: start_time
    }


  def cook(plate, seconds) do
    elapsed = seconds - plate.start_time
    %Plate{plate| pizza: Pizza.cook(plate.pizza, elapsed) }
  end

end
