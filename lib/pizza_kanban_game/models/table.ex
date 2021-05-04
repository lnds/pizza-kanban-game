defmodule PizzaKanbanGame.Models.Table do

  use StructAccess

  defstruct id: "",
            content: nil

  @type t() :: %__MODULE__{}

  alias PizzaKanbanGame.Models.{Table, Pizza, Ingredient}

  @spec new(Ingredient.t()) :: PizzaKanbanGame.Models.Table.t()
  def new(id),
    do: %Table {
      id: id
    }

  def drop(%Table{content: nil}=table, %Ingredient{kind: :crust}=crust) do
    %Table{table| content: Pizza.new(crust)}
  end

  def drop(%Table{content: nil}=table, ingredient) do
    %Table{table| content: ingredient}
  end

  def drop(%Table{content: %Pizza{ingredients: _}}=table, ingredient) do
    %Table{table| content: Pizza.add_ingredient(table.content, ingredient)}
  end

  def drop(table, _), do: table # do nothing if try to drop an ingredient over an ingredient

end
