defmodule Pluggy.PizzaController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredient
  alias Pluggy.Order
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]


  #Just send response
  def ingredients(conn), do: send_resp(conn, 200, render("pizzas/ingredients", ingredients: Ingredient.all()))

  def pizzas(conn), do: send_resp(conn, 200, render("pizzas/pizzas", pizzas: Pizza.all()))

  def order(conn), do: send_resp(conn, 200, render("pizzas/orders", orders: Order.all()))


  #Update database
  def add_order(conn, params) do
    Order.create(params)
    redirect(conn, "pizzas")
  end


  #Help functions
  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end


    def index(conn) do
      # get user if logged in
      session_user = conn.private.plug_session["user_id"]

      current_user =
        case session_user do
          nil -> nil
          _ -> User.get(session_user)
        end

      send_resp(conn, 200, render("pizzas/pizzas", ingredients: Ingredient.all(), user: current_user))
    end
end
