defmodule PizzaKanbanGameWeb.Board.Kitchen do

  use Surface.LiveComponent

  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore
  alias PizzaKanbanGame.Models.Pantry
  alias PizzaKanbanGameWeb.Board.{Table, PantryWidget}


  require Logger

  @topic "kitchen_events"

  def topic, do: @topic

  prop game_id, :string, default: ""
  data pizzas, :integer, default: 0
  data ingredients, :integer, default: 0

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
            <Table :for={{ table <- 1..9}} id="table-{{table}}" name="table-{{table}}" game_id="{{@game_id}}" />
        </div>
      </div>
    """
  end


  def handle_event("drop", %{"topping" => topping, "image" => image, "to" => table, "from" => from}, socket) do
    topping = %{topping: topping, image: image}
    get_game_id(socket)
      |> GameStore.get()
      |> GameStore.update_table(table, topping)
      |> drop_topping(socket, from, topping.topping, table)
  end

  def handle_event("pop", %{"from" => table}, socket) do
    get_game_id(socket)
      |> GameStore.get()
      |> GameStore.pop_table(table)
      |> refresh_table(socket, table)
  end

  defp get_game_id(socket) do
    socket.assigns.game_id
  end

  def broad_cast(game, :update_pantry) do
    Game.broadcast({:ok, game}, @topic, :update_pantry, nil)
  end


  # do the drop topping stuff

  defp drop_topping({:error, _}, socket, _, _, _), do: {:noreply, socket}

  defp drop_topping({:ok, game}, socket, "pantry", topping, table) do
    {:ok, pantry} = Pantry.remove_ingredient(game.pantry, topping)
    game = %Game{game | pantry: pantry}
    PantryWidget.refresh(pantry)
    GameStore.save(game)
    Game.broadcast({:ok, game}, @topic, :update_pantry, nil)
    refresh_table({:ok, game}, socket, table) ## reuse impl from below
  end

  defp drop_topping({:ok, game}, socket, _, _, table) do
    refresh_table({:ok, game}, socket, table) ## reuse impl from below
  end

  defp refresh_table({:ok, game}, socket, table) do
    Table.refresh(game, table)
    Game.broadcast({:ok, game}, @topic, :update_table, table)
    {:noreply, socket }
  end

end
