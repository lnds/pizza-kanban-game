defmodule PizzaKanbanGame.PantryStore do
  use PizzaKanbanGame.Store
  alias PizzaKanbanGame.Models.{Pantry, PantrySlot, Ingredient}

  require Logger

  def save(%Pantry{id: id} = pantry) do
    {:ok, persist(id, pantry)}
  end

  def find_game_pantry(game_id) do
    with {:ok, pantry} <- get_by(&has_game_id?(&1, game_id)) do
      {:ok, pantry}
    else
      _ -> Pantry.new(game_id) |> save()
    end
  end

  def remove_ingredient({:error, _reason}=error, _ingredient_id), do: error

  def remove_ingredient({:ok, pantry}, ing) do
    Logger.info("")
    Logger.info("!!!remove_ingredient (#{inspect(ing)})")
    {changed_slot, slots} =  get_and_update_in(pantry.slots, [Access.filter(fn slot -> Utils.string_equals?(slot.ingredient.id, ing) end)], fn slot -> {slot, %PantrySlot{slot| quantity: slot.quantity-1}} end)
    Logger.info("!!!CHANGED SLOT (#{inspect(changed_slot)})")
    if length(changed_slot) == 0 do
      {:error, :empty_slot}
    else
      [changed_slot|_] = changed_slot
      if changed_slot.quantity > 0 do
        {:ok, persist(pantry.id, %{pantry | slots: slots})}
      else
        {:error, :empty_slot}
      end
    end
  end

  def has_game_id?(%{game_id: game_id}, id), do: Utils.string_equals?(game_id, id)
end
