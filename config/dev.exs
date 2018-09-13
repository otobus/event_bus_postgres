use Mix.Config

# Configure your database
config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres
