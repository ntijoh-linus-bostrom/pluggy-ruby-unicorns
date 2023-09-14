defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", ingredients: 0, image: "")

  alias Pluggy.Pizza
  alias Pluggy.Ingredients

  def all do
    Postgrex.query!(DB, "SELECT * FROM pizzas", [], pool: DBConnection.ConnectionPool).rows
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

  # defp to_struct([[id, name, ingredients, image]]) do
  #   %Pizza{id: id, name: name, ingredients: ingredients, image: image}
  # end

  defp to_struct_list(rows) do
    for [id, name, ingredients, image] <- rows, do: %Pizza{id: id, name: name, ingredients: list_ingredients(ingredients), image: image}
  end

  defp list_ingredients(num) do
    Integer.digits(num, 2)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce([], (fn {binary, index}, output -> if binary == 1, do: [index | output], else: output end))
    |> Enum.reduce([], fn index, output -> [Ingredients.get(index) | output] end)
    |> Enum.reduce([], fn %Ingredients{id: _id, name: name}, output -> [name | output] end)
    |> Enum.reverse()
  end

end
