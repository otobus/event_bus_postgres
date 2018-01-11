use Mix.Config

# Configure your database
config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "mustafaturan",
  password: "123456",
  database: "event_bus_postgres_dev",
  hostname: "localhost",
  pool_size: 1
