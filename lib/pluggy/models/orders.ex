defmodule Pluggy.Order do
  defstruct(id: nil, name: "", ingredients: 0, done: nil, paid_for: nil, picked_up: nil)

  alias Pluggy.Order
  alias Pluggy.Ingredient
  alias Pluggy.Pizza


  #Main functions
  def all do
    Postgrex.query!(DB, "SELECT * FROM orders", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def create(params) do
    name = params["name"]
    ingredients = Pizza.get_ingredients_from_name(name)
    Postgrex.query!(DB, "INSERT INTO orders (name, ingredients) VALUES ($1, $2)", [name, ingredients], pool: DBConnection.ConnectionPool)
  end


  #Struct handling
  defp to_struct_list(rows) do
    for [id, name, ingredients, done, paid_for, picked_up] <- rows, do: %Order{id: id, name: name, ingredients: Ingredient.int_to_list(ingredients), done: done, paid_for: paid_for, picked_up: picked_up}
  end


end
