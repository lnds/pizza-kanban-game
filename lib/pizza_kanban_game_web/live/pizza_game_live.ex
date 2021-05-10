defmodule PizzaKanbanGameWeb.PizzaGameLive do
  use Surface.LiveView

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.{PantryWidget, KitchenWidget, OvenWidget, OrdersWidget, ResultsWidget}
  alias PizzaKanbanGame.PlayerStore
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore
  alias PizzaKanbanGame.Models.Oven

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
        <%= live_component @socket, OrdersWidget, id: "orders", game: @game %>
        <%= live_component @socket, ResultsWidget, id: "results", game: @game %>
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
  def handle_info({:update, game, _}, socket) do
    game_id = socket.assigns.game.id
    if game.id == game_id do
      refresh(game)
      {:noreply, assign(socket, :game, game)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:oven_clock_start, socket) do
    oven = socket.assigns.game.oven
    oven = Oven.turn_on(oven)
    game = %Game{socket.assigns.game| oven: oven}
    KitchenWidget.save(game)
    :timer.send_after(1000, self(), :oven_tick)
    {:noreply, assign(socket, :game, game)}
  end

  def handle_info(:oven_tick, socket) do
    oven = socket.assigns.game.oven
    if oven.on do
      oven = Oven.cook(oven)
      game = %Game{socket.assigns.game| oven: oven}
      KitchenWidget.save(game)
      :timer.send_after(1000, self(), :oven_tick)
      {:noreply, assign(socket, :game, game)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:oven_clock_stop, socket) do
    {oven, plates} = Oven.turn_off(socket.assigns.game.oven) |> Oven.remove_plates()
    game = %Game{socket.assigns.game| oven: oven} |> Game.verifiy_plates(plates)
    OvenWidget.refresh(game)
    KitchenWidget.save(game)
    {:noreply, assign(socket, :game, game)}
  end

  def refresh(game) do
    PantryWidget.refresh(game)
    KitchenWidget.refresh(game)
    OvenWidget.refresh(game)
    OrdersWidget.refresh(game)
    ResultsWidget.refresh(game)
    game
  end

  defp create_game({:error, _reason}, game_id) do
    {:ok, player} = PlayerStore.create()
    game = Game.new_with_id(game_id, player.name, player)
    GameStore.save(game)
    game
  end

  defp create_game({:ok, game}, _game_id) do
    refresh(game)
  end


end
