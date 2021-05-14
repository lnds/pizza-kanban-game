defmodule PizzaKanbanGameWeb.PizzaGameLive do
  use Surface.LiveView

  alias PizzaKanbanGameWeb.Router.Helpers, as: Routes
  alias PizzaKanbanGameWeb.Board.{PantryWidget, KitchenWidget, OvenWidget, OrdersWidget, ResultsWidget, ScoreWidget, ClockWidget}
  alias PizzaKanbanGame.PlayerStore
  alias PizzaKanbanGame.Game
  alias PizzaKanbanGame.GameStore
  alias PizzaKanbanGame.Models.Oven

  require Logger

  data game, :struct, default: nil
  data game_clock, :integer, default: 0
  data oven_clock_active, :boolean, default: false

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
      <nav class="flex items-center justify-between flex-wrap bg-teal-500 p-6  divide-x-2 divide-green-500">
        <div class="flex items-center flex-shrink-0 text-black mr-6">
          <div class="h-12 w-12 py-2 px-4 relative ">
            <img class="absolute top-0 left-0 z-0" src="<%= Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/pizza_crust.png") %>" />
            <img class="absolute top-0 left-0 z-auto" src="<%= Routes.static_path(PizzaKanbanGameWeb.Endpoint, "/images/sauce.png") %>" />
          </div>
          <span class="font-semibold text-xl tracking-tight">Pizza Kanban Simulator</span>
        </div>
        <div class="block lg:hidden">
          <button class="flex items-center px-3 py-2 border rounded text-teal-200 border-teal-400 hover:text-white hover:border-white">
            <svg class="fill-current h-3 w-3" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><title>Menu</title><path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"/></svg>
          </button>
        </div>
        <div class="w-full block ml-4 px-4 flex-grow lg:flex lg:items-center lg:w-auto">
          <div class="text-sm lg:flex-grow">
            <a href="#responsive-header" class="block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4">
              Ayuda
            </a>
            <a href="#responsive-header" class="block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4">
              Gráficos
            </a>
          </div>
          <div>
            <%= live_component @socket, ClockWidget, id: "clock", game: @game %>
          </div>
          <div>
            <span class="inline-block text-sm px-4 py-2 leading-none   text-black border-black  mt-4 lg:mt-0"></span>
          </div>
          <div>
            <%= live_component @socket, ScoreWidget, id: "score", game: @game %>
          </div>
        </div>
      </nav>
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
    Logger.info("HANDLE_PARAMS 1 #{inspect(socket.assigns.game.id)} !")
    if connected?(socket), do: Game.subscribe(game)
    {:noreply, socket}
  end

  def handle_params(%{}, _uri, socket) do
    {:ok, player} = PlayerStore.create()
    game = Game.new(player.name, player)
    GameStore.save(game)
    socket = socket |> assign(:game, game)
    Logger.info("HANDLE_PARAMS 2 #{inspect(socket.assigns.game.id)} !")
    {:noreply, push_redirect(socket,  to: "/#{game.id}", replace: true)}
  end

  @impl true
  def handle_info({event, game, _}, socket) do
    if socket.assigns.game && game.id == socket.assigns.game.id do
      handle_game_event(event, game, socket)
    else
      {:noreply, socket}
    end
  end

  def handle_info(event, socket) do
    handle_clock_event(event, socket.assigns.game, socket)
  end

  def handle_game_event(:update, game, socket) do
    refresh(game)
    {:noreply, assign(socket, :game, game)}
  end

  def handle_clock_event(:oven_clock_start, game, socket) do
    oven = game.oven
    oven = Oven.turn_on(oven)
    game = %Game{socket.assigns.game| oven: oven}
    KitchenWidget.save(game)
    :timer.send_after(1000, self(), :oven_tick)
    {:noreply, assign(socket, :game, game)}
  end

  def handle_clock_event(:oven_tick, game, socket) do
    oven = game.oven
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

  def handle_clock_event(:oven_clock_stop, game, socket) do
    {oven, plates} = Oven.turn_off(game.oven) |> Oven.remove_plates()
    game = %Game{socket.assigns.game| oven: oven} |> Game.verifiy_plates(plates)
    OvenWidget.refresh(game)
    KitchenWidget.save(game)
    {:noreply, assign(socket, :game, game)}
  end

  @round_duration 300

  def handle_clock_event(:game_start_round, game, socket) do
    game = %Game{game| clock: @round_duration}
    KitchenWidget.save(game)
    :timer.send_after(1000, self(), :game_tick)
    {:noreply, assign(socket, :game, game)}
  end

  def handle_clock_event(:game_tick, game, socket) do
    game = if game.clock > 0 do
      :timer.send_after(1000, self(), :game_tick)
      %Game{game| clock: game.clock - 1}
    else
      if game.oven.on do
        send(self(), :oven_clock_stop)
      end
      %Game{game| clock: 0, score: game.score + Game.score(game)}
    end
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
