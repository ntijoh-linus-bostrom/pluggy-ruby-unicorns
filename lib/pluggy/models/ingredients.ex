defmodule Pluggy.Ingredient do
  defstruct(id: nil, name: "")

  alias Pluggy.Ingredient


  #Main functions
  def all do
    Postgrex.query!(DB, "SELECT * FROM ingredients", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM ingredients WHERE id = $1 LIMIT 1", [id], pool: DBConnection.ConnectionPool).rows
    |> to_struct
  end


  #Struct handling
  defp to_struct([[id, name]]) do
    %Ingredient{id: id, name: name}
  end

  defp to_struct_list(rows) do
    for [id, name] <- rows, do: %Ingredient{id: id, name: name}
  end


  #Help functions
  def int_to_list(num) do
    Integer.digits(num, 2)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce([], (fn {binary, index}, output -> if binary == 1, do: [index | output], else: output end))
    |> Enum.reduce([], fn index, output -> [Ingredient.get(index) | output] end)
    |> Enum.reduce([], fn %Ingredient{id: _id, name: name}, output -> [name | output] end)
    |> Enum.reverse()
  end



  #For the future:

  # def get_id(name) do
  #   Postgrex.query!(DB, "SELECT id FROM ingredients WHERE name = $1 LIMIT 1", [name], pool: DBConnection.ConnectionPool).rows
  # end

  # def size() do
  #   Postgrex.query!(DB, "SELECT COUNT(id) FROM ingredients;", [], pool: DBConnection.ConnectionPool).rows
  #   |> List.flatten()
  #   |> hd()
  # end

  # def list_to_int(name_list) do
  #   id_list = Enum.reduce(name_list, [], fn name, output -> [ Ingredient.get_id(name) | output] end)
  #   Enum.reduce(Enum.to_list(Range.new(1, Ingredient.size())), [], (fn i, acc -> (if Enum.member?(id_list, i), do: List.replace_at(acc, i - 1, "1"), else: List.replace_at(acc, i - 1, "0")) end))
  #   |> Enum.reduce("", fn bit, string -> string <> bit end)
  #   |> String.to_integer(2)
  # end
end
