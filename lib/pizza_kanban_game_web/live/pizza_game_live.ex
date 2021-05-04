defmodule PizzaKanbanGameWeb.PizzaGameLive do
  use Surface.LiveView

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.{Table, PantryWidget, Kitchen, Oven, Dispatch, PlayersBoard}
  alias PizzaKanbanGame.PlayerStore
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore

  require Logger


  data game_id, :string, default: ""
  data oven_clock, :integer, default: 0
  data oven_clock_active, :boolean, default: false

  @impl true
  def render(assigns) do
    ~L"""
        <header class="">
        <a href="#" class="phx-logo">
          <img src="<%= Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/app_logo.png") %>" alt="Pizza Kanban Simulator"/>
        </a>
      </header>
      <div id="game" class="font-sans antialiased flex w-screen h-full">
          <%= live_component @socket, PantryWidget, id: "pantry", game_id: @game_id %>
          <%= live_component @socket, Kitchen, id: "kitchen", game_id: @game_id %>
          <%= live_component @socket, Oven, id: "oven", game_id: @game_id %>
          <%= live_component @socket, Dispatch, id: "dispatch" %>
          <%= live_component @socket, PlayersBoard, id: "players" %>
        </div>
    """
  end

  @impl true
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    GameStore.get(game_id) |> create_game(game_id)
    socket = socket |> assign(:game_id, game_id)
    {:noreply, socket}
  end

  def handle_params(%{}, _uri, socket) do
    {:ok, player} = PlayerStore.create()
    game = Game.new(player.name, player)
    GameStore.save(game)
    {:noreply, push_redirect(socket,  to: "/#{game.id}", replace: true)}
  end

  @impl true
  def handle_info({:update_table, game, table}, socket) do
    game_id = socket.assigns.game_id
    if game.id == game_id do
      {:ok, game} = GameStore.get(game.id)
      Table.refresh(game, table)
    end
    {:noreply, socket}
  end

  def handle_info(:oven_clock_start, socket) do
    :timer.send_after(1000, self(), :oven_tick)
    {:noreply, socket |> assign(oven_clock_active: true)}
  end

  def handle_info(:oven_tick, socket) do
    oven_clock = socket.assigns.oven_clock + 1
    Oven.tick(oven_clock, socket.assigns.oven_clock_active)
    {:noreply, socket |> assign(oven_clock: oven_clock)}
  end

  def handle_info(:oven_clock_stop, socket) do
    {:noreply, socket |> assign(oven_clock_active: false) |> assign(oven_clock: -1)}
  end

  def handle_info({:update_pantry, game, _}, socket) do
    game_id = socket.assigns.game_id
    if game.id == game_id do
      {:ok, game} = GameStore.get(game.id)
      PantryWidget.refresh(game.pantry)
    end
    {:noreply, socket}
  end

  defp create_game({:error, _reason}, game_id) do
    {:ok, player} = PlayerStore.create()
    game = Game.new_with_id(game_id, player.name, player)
    GameStore.save(game)
  end

  defp create_game({:ok, game}, _game_id) do
    PantryWidget.refresh(game.pantry)
    Enum.each(Map.keys(game.tables), fn table_id -> Table.refresh(game, table_id) end)
    Oven.refresh(game)
  end


end
