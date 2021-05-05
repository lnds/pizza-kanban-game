defmodule PizzaKanbanGame.Models.Oven do

  use StructAccess

  defstruct id: "oven",
            plates: [],
            limit: 0,
            clock: 0

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Oven, Plate, Pizza}

  @spec new(integer) :: PizzaKanbanGame.Models.Oven.t()
  def new(limit),  do:
    %Oven {
      limit: limit
    }

  @spec put_pizza(Oven.t(), Pizza.t()) :: {:ok, Oven.t()}
  def put_pizza(oven, %Pizza{ingredients: _}=pizza) when length(pizza.plates) < oven.limit do
      {:ok, %Oven{oven| plates: [Plate.new(pizza) | oven.plates]} }
  end



end
