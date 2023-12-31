defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")

    #Table containing standard pizzas
    Postgrex.query!(DB, "CREATE TABLE pizzas (
      id SERIAL,
      name VARCHAR(255) NOT NULL,
      ingredients INTEGER NOT NULL,
      image VARCHAR(255) NOT NULL
    )", [], pool: DBConnection.ConnectionPool)

    #Table listing and indexing all ingredients
    Postgrex.query!(DB, "CREATE TABLE ingredients (
      id SERIAL,
      name VARCHAR(255) NOT NULL
    )", [], pool: DBConnection.ConnectionPool)

    #Table containing all orders
    Postgrex.query!(DB, "CREATE TABLE orders (
      id SERIAL,
      name VARCHAR(255) NOT NULL,
      ingredients INTEGER NOT NULL,
      done BOOLEAN NOT NULL DEFAULT false,
      paid_for BOOLEAN NOT NULL DEFAULT false,
      picked_up BOOLEAN NOT NULL DEFAULT false
    )", [], pool: DBConnection.ConnectionPool)

  end

  defp seed_data() do
    IO.puts("Seeding data")

    #Seeding all ingredients and modifiers such as gluten free
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Gluten"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Family"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Tomato"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Mozarella"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Parmesan"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Gorgonzola"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Pecorino"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Ham"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Salami"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Olives"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Paprika"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Zuccini"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Auburgine"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Artichoke"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Mushrooms"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Chilli"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Basil"], pool: DBConnection.ConnectionPool)

    #Seeding all standard pizzas
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Marinara", 4, "marinara.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Quattro formaggi", 124, "quattro-formaggi.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Margherita", 65548, "margherita.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Prosciutto e funghi", 16524, "prosciutto-e-funghi.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Capricciosa", 24716, "capricciosa.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Quattro stagioni", 25228, "quattro-stagioni.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Diavola", 34060, "diavola.svg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name, ingredients, image) VALUES($1, $2, $3)", ["Ortolana", 7180, "ortolana.svg"], pool: DBConnection.ConnectionPool)


    #Postgrex.query!(DB, "INSERT INTO orders(name, ingredients, done, paid_for, picked_up) VALUES($1, $2, $3, $4, $5)", ["Marinara", 4, false, false, false], pool: DBConnection.ConnectionPool)
  end

end
