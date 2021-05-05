defmodule PizzaKanbanGameWeb.PizzaGameLive do
  use Surface.LiveView

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.{PantryWidget, KitchenWidget, OvenWidget}
  alias PizzaKanbanGame.PlayerStore
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore

  require Logger

  data game, :struct, default: nil
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
      <main id="game" class="font-sans antialiased flex w-screen h-full h-auto ">
        <%= live_component @socket, PantryWidget, id: "pantry", game: @game %>
        <%= live_component @socket, KitchenWidget, id: "kitchen", game: @game %>
        <%= live_component @socket, OvenWidget, id: "oven", game: @game %>
      </main>
    """
  end

  @impl true
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    game = GameStore.get(game_id) |> create_game(game_id)
    socket = socket |> assign(:game, game)
    {:noreply, socket}
  end

  def handle_params(%{}, _uri, socket) do
    {:ok, player} = PlayerStore.create()
    game = Game.new(player.name, player)
    GameStore.save(game)
    {:noreply, push_redirect(socket,  to: "/#{game.id}", replace: true)}
  end

  @impl true
  def handle_info({:update_kitchen, game, _}, socket) do
    game_id = socket.assigns.game.id
    if game.id == game_id do
      {:ok, game} = GameStore.get(game.id)
      KitchenWidget.refresh(game)
      {:noreply, assign(socket, :game, game)}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:update_pantry, game, _}, socket) do
    game_id = socket.assigns.game.id
    if game.id == game_id do
      {:ok, game} = GameStore.get(game.id)
      PantryWidget.refresh(game)
      {:noreply, assign(socket, :game, game)}
    else
      {:noreply, socket}
    end
  end

  defp create_game({:error, _reason}, game_id) do
    {:ok, player} = PlayerStore.create()
    game = Game.new_with_id(game_id, player.name, player)
    GameStore.save(game)
    game
  end

  defp create_game({:ok, game}, _game_id) do
    PantryWidget.refresh(game)
    KitchenWidget.refresh(game)
    OvenWidget.refresh(game)
    game
  end


end
