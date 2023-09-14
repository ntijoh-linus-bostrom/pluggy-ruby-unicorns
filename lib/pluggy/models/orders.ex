defmodule Pluggy.Order do
  defstruct(id: nil, name: "", ingredients: 0, done: nil, paid_for: nil, picked_up: nil)

  alias Pluggy.Order
  alias Pluggy.Ingredient

  def all do
    Postgrex.query!(DB, "SELECT * FROM orders", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  # def get(id) do
  #   Postgrex.query!(DB, "SELECT * FROM fruits WHERE id = $1 LIMIT 1", [String.to_integer(id)],
  #     pool: DBConnection.ConnectionPool
  #   ).rows
  #   |> to_struct
  # end

  # def update(id, params) do
  #   name = params["name"]
  #   tastiness = String.to_integer(params["tastiness"])
  #   id = String.to_integer(id)

  #   Postgrex.query!(
  #     DB,
  #     "UPDATE fruits SET name = $1, tastiness = $2 WHERE id = $3",
  #     [name, tastiness, id],
  #     pool: DBConnection.ConnectionPool
  #   )
  # end

  # def create(params) do
  #   name = params["name"]
  #   tastiness = String.to_integer(params["tastiness"])

  #   Postgrex.query!(DB, "INSERT INTO fruits (name, tastiness) VALUES ($1, $2)", [name, tastiness],
  #     pool: DBConnection.ConnectionPool
  #   )
  # end

  # def delete(id) do
  #   Postgrex.query!(DB, "DELETE FROM fruits WHERE id = $1", [String.to_integer(id)],
  #     pool: DBConnection.ConnectionPool
  #   )
  # end

  # @spec to_struct([[...], ...]) :: %Pluggy.Fruit{id: any, name: any, tastiness: any}
  # def to_struct([[id, name, tastiness]]) do
  #   %Fruit{id: id, name: name, tastiness: tastiness}
  # end

  defp to_struct_list(rows) do
    for [id, name, ingredients, done, paid_for, picked_up] <- rows, do: %Order{id: id, name: name, ingredients: Ingredient.list_ingredients(ingredients), done: done, paid_for: paid_for, picked_up: picked_up}
  end


end
