defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  # alias Pluggy.FruitController
  alias Pluggy.PizzaController
  alias Pluggy.UserController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)


  #GET routes
  get("/ingredients", do: PizzaController.ingredients(conn))
  get("/pizzas", do: PizzaController.pizzas(conn))
  get("/orders", do: PizzaController.order(conn))

  #POST routes
  post("add_order", do: PizzaController.add_order(conn, conn.body_params))

  #Error handling
  match _ do
    send_resp(conn, 404, "Error: 404. Route not found.")
  end



  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("/users/logout", do: UserController.logout(conn))

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
