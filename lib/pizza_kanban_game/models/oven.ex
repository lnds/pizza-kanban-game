defmodule PizzaKanbanGame.Models.Oven do

  use StructAccess

  require Logger

  defstruct id: "oven",
            plates: [],
            limit: 0,
            clock: 0,
            on: false

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Oven, Plate, Pizza}

  @spec new(integer) :: PizzaKanbanGame.Models.Oven.t()
  def new(limit),  do:
    %Oven {
      limit: limit
    }

  @spec put_pizza(Oven.t(), Pizza.t()) :: {:ok, Oven.t()} | {:error, Oven.t()}
  def put_pizza(oven, %Pizza{ingredients: _}=pizza) when length(oven.plates) < oven.limit do
      Logger.info("!!por aca #{inspect(pizza)}")

      {:ok, %Oven{oven| plates: [Plate.new(pizza) | oven.plates]} }
  end

  def put_pizza(oven, pizza) do
    Logger.info("!!por alla #{inspect(pizza)}")

    {:error, oven}
  end

  @spec turn_on(PizzaKanbanGame.Models.Oven.t()) :: PizzaKanbanGame.Models.Oven.t()
  def turn_on(oven) do
    %Oven{oven | on: true, clock: 0}
  end

  @spec turn_off(PizzaKanbanGame.Models.Oven.t()) :: PizzaKanbanGame.Models.Oven.t()
  def turn_off(oven) do
    %Oven{oven | on: false, clock: 0}
  end

end
