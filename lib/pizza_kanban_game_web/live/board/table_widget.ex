defmodule PizzaKanbanGameWeb.Board.TableWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Board.TableContentWidget
  require Logger

  prop table, :struct, default: nil
  prop game, :struct, default: nil

  def render(assigns) do
    ~H"""
      <div class="group flex flex-col py-4 px-4
                 max-w-sm mx-auto bg-white rounded-xl shadow-md space-y-1 sm:py-2 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">
        <TableContentWidget table={{@table}} id="{{@table.id}}" game={{@game}} />
      </div>
    """
  end



end
