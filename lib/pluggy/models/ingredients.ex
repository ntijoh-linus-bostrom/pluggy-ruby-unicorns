defmodule Pluggy.Ingredients do
  defstruct(id: nil, name: "")

  alias Pluggy.Ingredients

  def all do
    Postgrex.query!(DB, "SELECT * FROM ingredients", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM ingredients WHERE id = $1 LIMIT 1", [id], pool: DBConnection.ConnectionPool).rows
    |> to_struct
  end

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

  def to_struct([[id, name]]) do
    %Ingredients{id: id, name: name}
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Ingredients{id: id, name: name}
  end

  def get(num) do
    Integer.digits(num, 2)
    Postgrex.query!(DB, "SELECT * FROM ingredients ORDER BY id", [], pool: DBConnection.ConnectionPool).rows

  end
end
