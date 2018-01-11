use Mix.Config

config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "1"),
  ssl: true
