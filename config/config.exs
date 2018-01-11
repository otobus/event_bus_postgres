use Mix.Config

config :event_bus_postgres, ecto_repos: [EventBus.Postgres.Repo]

config :event_bus_postgres,
  enabled: {:system, "EB_PG_ENABLED", "true"},
  persist_in_ms: {:system, "EB_PG_PERSIST_IN_MS", "100"},
  topics: {:system, "EB_PG_TOPICS", ".*"},
  default_ttl_in_ms: {:system, "EB_PG_DEFAULT_TTL_IN_MS", "900000"},
  deletion_period_in_ms: {:system, "EB_PG_DELETION_PERIOD_IN_MS", "600000"}

import_config "#{Mix.env}.exs"
