defmodule PizzaKanbanGame.Namer do
  @titles ~w(piña anchoas salame mozarella queso tomate pimenton cebolla salsa champiñon pollo cheddar pastrami cebollín carne tocino chorizo)
  @size 2

  @spec make :: binary
  def make() do
    @titles
    |> Enum.shuffle()
    |> Enum.take(@size)
    |> Enum.map(&Macro.camelize/1)
    |> Enum.join(" con ")
  end
end
