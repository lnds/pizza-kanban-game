defmodule PizzaKanbanGameWeb.Board.KitchenWidget do

  use Surface.LiveComponent

  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore
  alias PizzaKanbanGame.Models.{Kitchen, Pantry}
  alias PizzaKanbanGameWeb.Board.{TableWidget, PantryWidget}


  require Logger

  @topic "kitchen_events"

  def topic, do: @topic

  prop game_id, :string, default: ""
  data tables, :list, default: []


  def mount(socket) do
    if connected?(socket), do: Game.subscribe(@topic)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div id="kitchen" class="flex-1 flex flex-col bg-gray-700 overflow-hidden">
        <div class="border-b border-gray-600 flex px-6 py-2 items-center flex-none shadow-xl">
          <!-- header -->
          <div class="flex flex-col">
            <h3 class="text-white mb-1 font-bold text-xl text-gray-100 flex flex-inline">
              Cocina
              <span class="mx-4 flex flex-inline w-max mb-2 font-normal text-base">
                <ul class="ml-auto flex justify-items-center">
                  <li>game id: {{@game_id}}</li>
                </ul>
              </span>
            </h3>
          </div>
          <!-- end header -->
        </div>
        <div class="flex flex-wrap justify-center gap-4">
            <TableWidget :for={{ table <- @tables }}  table={{table}} game_id="{{@game_id}}" />
        </div>
      </div>
    """
  end


  def handle_event("drop", %{"topping" => topping, "image" => _image, "to" => table_name, "from" => from}, socket) do
    get_game_id(socket)
      |> GameStore.get()
      |> drop_topping(socket, from, topping, table_name)
  end

  defp get_game_id(socket) do
    socket.assigns.game_id
  end

  def broad_cast(game, :update_pantry) do
    Game.broadcast({:ok, game}, @topic, :update_pantry, nil)
  end

  def refresh(kitchen) do
    send_update(__MODULE__, id: "kitchen", tables: kitchen.tables)
  end

  # do the drop topping stuff

  defp drop_topping({:error, _}, socket, _, _, _), do: {:noreply, socket}

  defp drop_topping({:ok, game}, socket, "pantry", topping, table_name) do
    Pantry.remove_ingredient(game.pantry, topping) |> put_topping_on_table(socket, game, table_name)
  end

  defp drop_topping({:ok, game}, socket, from, topping_id, to) do
    game.pantry
      |> Pantry.get_ingredient_by_id(topping_id)
      |> Kitchen.move_topping(game.kitchen, from, to)
      |> validate_move(socket, game)
  end

  defp put_topping_on_table({:ok, pantry, slot}, socket, game, table_name) do
    Kitchen.drop(game.kitchen, table_name, slot.ingredient)
      |> validate_drop(socket, game, pantry)
  end

  defp validate_drop({:error, _table}, socket, _, _), do: {:noreply, socket}

  defp validate_drop({:ok, table}, socket, game, pantry) do
    game = %Game{game | pantry: pantry, kitchen: Kitchen.update_table(game.kitchen, table)}
    PantryWidget.refresh(pantry)
    refresh(game.kitchen)
    GameStore.save(game)
    Game.broadcast({:ok, game}, @topic, :update_pantry, nil)
    {:noreply, socket }
  end

  defp validate_move({:error, _kitchen}, socket, _), do: {:noreply, socket}

  defp validate_move({:ok, kitchen}, socket, game) do
    refresh(kitchen)
    %Game{game| kitchen: kitchen}
    |> GameStore.save()
    |> Game.broadcast(@topic, :update_kitchen, nil)
    {:noreply, socket}
  end

end
