defmodule PizzaKanbanGameWeb.PizzaGameLive do
  use Surface.LiveView

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.{Table, Pantry, Kitchen, Oven, Dispatch, PlayersBoard}
  alias PizzaKanbanGameWeb.PlayerStore
  alias PizzaKanbanGame.Game

  require Logger

  data game_id, :string, default: ""

  @impl true
  def render(assigns) do
    ~L"""
        <header class="">
        <a href="#" class="phx-logo">
          <img src="<%= Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/app_logo.png") %>" alt="Pizza Kanban Simulator"/>
        </a>
      </header>
      <div id="game" class="font-sans antialiased flex w-screen h-full">
          <%= live_component @socket, Pantry, id: "pantry" %>
          <%= live_component @socket, Kitchen, id: "kitchen" %>
          <%= live_component @socket, Oven, id: "oven" %>
          <%= live_component @socket, Dispatch, id: "dispatch" %>
          <%= live_component @socket, PlayersBoard, id: "players" %>
        </div>
    """
  end

  @impl true
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    Kitchen.set_game_id(game_id)
    socket = socket |> assign(:game_id, game_id)
    {:noreply, socket}
  end

  def handle_params(%{}, _uri, socket) do
    {:ok, player} = PlayerStore.create()
    game = Game.new(player.name, player)
    send_update(PlayersBoard, id: "players", players: game.players)
    {:noreply, push_redirect(socket,  to: "/#{game.id}", replace: true)}
  end

  @impl true
  def handle_info({:drop_topping, {game, topping, table}}, socket) do
    game_id = socket.assigns.game_id
    Logger.info("game id is = #{game_id}")
    if game == game_id, do: Table.push_topping(table, topping)
    {:noreply, socket}
  end

end
