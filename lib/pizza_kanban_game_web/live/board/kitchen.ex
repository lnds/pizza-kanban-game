defmodule PizzaKanbanGameWeb.Board.Kitchen do

  use Surface.LiveComponent

  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.{GameStore, PantryStore}
  alias PizzaKanbanGameWeb.Board.{Table, PantryWidget}


  require Logger

  @topic "kitchen_events"

  def topic, do: @topic

  prop game_id, :string, default: ""
  data pizzas, :integer, default: 0
  data ingredients, :integer, default: 0

  def mount(socket) do
    if connected?(socket), do: Game.subscribe(@topic)
    Logger.info("MOUNT #{inspect(socket.assigns)}")
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
    Logger.info("drop topping to = #{inspect(table)}, from = #{inspect(from)}")
    topping = %{topping: topping, image: image}
    game_id = get_game_id(socket)
    if from == "pantry" do
      if PantryWidget.remove_ingredient(game_id, topping.topping) do
        {:ok, game} = GameStore.get(game_id) |> GameStore.update_table(table, topping)
        Table.refresh(game, table)
        Game.broadcast({:ok, game}, @topic, :update_table, table)
      end
    else
      {:ok, game} = GameStore.get(game_id) |> GameStore.update_table(table, topping)
      Table.refresh(game, table)
      Game.broadcast({:ok, game}, @topic, :update_table, table)
    end
    {:noreply, socket }
  end

  def handle_event("pop", %{"from" => table}, socket) do
    Logger.info("pop #{inspect(table)}")
    game_id = get_game_id(socket)
    {:ok, game} = GameStore.get(game_id)
      |> GameStore.pop_table(table)
    Table.refresh(game, table)
    Game.broadcast({:ok, game}, @topic, :update_table, table)
    {:noreply, socket}
  end

  defp get_game_id(socket) do
    socket.assigns.game_id
  end
end
