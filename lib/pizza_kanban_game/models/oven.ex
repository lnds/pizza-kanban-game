defmodule PizzaKanbanGame.Models.Oven do

  use StructAccess

  require Logger

  defstruct id: "oven",
            plates: [],
            limit: 0,
            clock: 0,
            on: false

  @type t() :: %__MODULE__{}

  @raw_time 30

  @burn_time 45

  alias PizzaKanbanGame.Models.{Oven, Plate, Pizza}

  @spec new(integer) :: PizzaKanbanGame.Models.Oven.t()
  def new(limit),  do:
    %Oven {
      limit: limit
    }

  @spec put_pizza(Oven.t(), Pizza.t()) :: {:ok, Oven.t()} | {:error, Oven.t()}
  def put_pizza(%Oven{on: false}=oven, %Pizza{ingredients: _}=pizza) when length(oven.plates) < oven.limit do
      {:ok, %Oven{oven| plates: oven.plates ++ [Plate.new(pizza)]} }
  end

  def put_pizza(oven, _pizza), do:  {:error, oven}

  def accepts(oven, _pizza), do: !oven.on && length(oven.plates) < oven.limit

  @spec turn_on(PizzaKanbanGame.Models.Oven.t()) :: PizzaKanbanGame.Models.Oven.t()
  def turn_on(oven) do
    %Oven{oven | on: true, clock: 0}
  end

  @spec turn_off(PizzaKanbanGame.Models.Oven.t()) :: PizzaKanbanGame.Models.Oven.t()
  def turn_off(oven) do
    %Oven{oven | on: false}
  end

  def remove_plates(oven) do
    {%Oven{oven| plates: [], clock: 0}, oven.plates}
  end

  def cook(oven) do
    new_clock = oven.clock + 1
    %Oven{oven | clock: new_clock, plates: Enum.map(oven.plates, fn plate -> Plate.cook(plate, new_clock) end)}
  end


  def get_burning_state(clock) do
     cond do
      clock == 0 -> :dropped
      clock < @raw_time -> :cooking
      clock <= @burn_time -> :heating
      true -> :burned
    end
  end

end
