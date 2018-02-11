use Mix.Config

# Configure your database
config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env()["DATABASE_POSTGRESQL_USERNAME"] || "postgres",
  password: System.get_env()["DATABASE_POSTGRESQL_PASSWORD"] || "",
  database: "event_bus_postgres_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
