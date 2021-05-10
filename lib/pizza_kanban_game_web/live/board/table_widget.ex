defmodule PizzaKanbanGameWeb.Board.TableWidget do
  use Surface.Component

  alias PizzaKanbanGameWeb.Board.TableContentWidget
  require Logger

  prop table, :struct, default: nil
  prop game, :struct, default: nil

  def render(assigns) do
    ~H"""
        <div class="group flex-col py-2 px-2
                  max-w-sm mx-auto bg-white rounded-xl shadow-md space-y-1 flex items-center">
          <TableContentWidget table={{@table}} id="{{@table.id}}" game={{@game}} />
        </div>
    """
  end



end
