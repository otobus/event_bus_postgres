use Mix.Config

config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: true
