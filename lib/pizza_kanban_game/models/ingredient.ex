defmodule PizzaKanbanGame.Models.Ingredient do

  use StructAccess

  defstruct id: "",
            display_name: "",
            image: "",
            cost: 0,
            order: 0,
            kind: :undefined

  @type t() :: %__MODULE__{}

end
