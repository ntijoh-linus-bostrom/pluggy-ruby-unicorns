defmodule Pluggy.Ingredient do
  defstruct(id: nil, name: "")

  alias Pluggy.Ingredient

  def all do
    Postgrex.query!(DB, "SELECT * FROM ingredients", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM ingredients WHERE id = $1 LIMIT 1", [id], pool: DBConnection.ConnectionPool).rows
    |> to_struct
  end

  def get_id(name) do
    Postgrex.query!(DB, "SELECT id FROM ingredients WHERE name = $1 LIMIT 1", [name], pool: DBConnection.ConnectionPool).rows
  end

  def size() do
    Postgrex.query!(DB, "SELECT COUNT(id) FROM ingredients;", [], pool: DBConnection.ConnectionPool).rows
    |> List.flatten()
    |> hd()
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
    %Ingredient{id: id, name: name}
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Ingredient{id: id, name: name}
  end

  def int_to_list(num) do
    Integer.digits(num, 2)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce([], (fn {binary, index}, output -> if binary == 1, do: [index | output], else: output end))
    |> Enum.reduce([], fn index, output -> [Ingredient.get(index) | output] end)
    |> Enum.reduce([], fn %Ingredient{id: _id, name: name}, output -> [name | output] end)
    |> Enum.reverse()
  end

  def list_to_int(name_list) do
    id_list = Enum.reduce(name_list, [], fn name, output -> [ Ingredient.get_id(name) | output] end)
    Enum.reduce(Enum.to_list(Range.new(1, Ingredient.size())), [], (fn i, acc -> (if Enum.member?(id_list, i), do: List.replace_at(acc, i - 1, 1), else: List.replace_at(acc, i - 1, 0)) end))
  end
#Ha en god helg / william
  # defp to_binary(id_list), do: to_binary(id_list, Enum.to_list(1..Ingredient.size()))
  # defp to_binary(id_list, acc) do
  #   cond do
  #     (hd id_list) == (hd acc) -> [1 | to_binary((tl id_list), (tl acc))]
  #   end
  # end

  # def list_to_int(name_list) do
  #   id_list = Enum.reduce(name_list, [], fn name, output -> [ Ingredient.get_id(name) | output] end)
  #   Enum.reduce(Enum.to_list(1..17), [], fn i, output -> if Enum.member?(id_list, i), do: [1 | output], else: [0 | output] end)
  # end
end
