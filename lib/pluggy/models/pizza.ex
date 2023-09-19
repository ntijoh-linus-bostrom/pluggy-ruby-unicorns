defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", ingredients: 0, image: "")

  alias Pluggy.Pizza
  alias Pluggy.Ingredient


  #Main functions
  def all do
    Postgrex.query!(DB, "SELECT * FROM pizzas", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get_ingredients_from_name(name) do
    Postgrex.query!(DB, "SELECT ingredients FROM pizzas WHERE name = $1 LIMIT 1", [name], pool: DBConnection.ConnectionPool).rows
    |> List.flatten()
    |> hd()
  end


  #Struct handling
  defp to_struct_list(rows) do
    for [id, name, ingredients, image] <- rows, do: %Pizza{id: id, name: name, ingredients: Ingredient.int_to_list(ingredients), image: image}
  end


end
