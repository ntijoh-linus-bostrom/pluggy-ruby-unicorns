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

  def finish(params) do
    id = params["order_id"]
    Postgrex.query!(DB, "UPDATE orders SET done = true WHERE id = $1", [String.to_integer(id)], pool: DBConnection.ConnectionPool)
  end

  def pay_for(params) do
    id = params["order_id"]
    Postgrex.query!(DB, "UPDATE orders SET paid_for = true WHERE id = $1", [String.to_integer(id)], pool: DBConnection.ConnectionPool)
  end

  def pick_up(params) do
    id = params["order_id"]
    Postgrex.query!(DB, "UPDATE orders SET picked_up = true WHERE id = $1", [String.to_integer(id)], pool: DBConnection.ConnectionPool)
  end


  #Struct handling
  defp to_struct_list(rows) do
    for [id, name, ingredients, done, paid_for, picked_up] <- rows, do: %Order{id: id, name: name, ingredients: Ingredient.int_to_list(ingredients), done: done, paid_for: paid_for, picked_up: picked_up}
  end


end
