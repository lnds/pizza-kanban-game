defmodule PizzaKanbanGame.GameStore do
  use PizzaKanbanGame.Store
  alias PizzaKanbanGame.Game

  require Logger

  def save(%Game{id: id} = game) do
    {:ok, persist(id, game)}
  end


  @plate_limit 2

  def put_pizza_in_oven({:error, _reason}=error, _pizza), do: error

  def put_pizza_in_oven({:ok, %Game{id: id, plates: plates}=game}, pizza) do
    Logger.info("put pizza plates = #{inspect(plates)} !!!!")
    if plates == nil do
      new_game = %{game | plates: [pizza]}
      {:ok, persist(id, new_game)}
    else
      Logger.info("put pizza plates = #{inspect(plates)} !!!!")
      if length(plates) < @plate_limit do
        new_game = %{game | plates: plates ++ [pizza]}
        {:ok, persist(id, new_game)}
      else
        {:error, :plate_limit}
      end
    end
  end

end
