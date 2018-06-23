use Mix.Config

config :event_bus_postgres, ecto_repos: [EventBus.Postgres.Repo]

config :event_bus_postgres,
  enabled: {:system, "EB_PG_ENABLED", "true"},
  auto_delete_with_ttl: {:system, "EB_PG_AUTO_DELETE_WITH_TTL", "true"},
  min_demand: {:system, "EB_PG_MIN_DEMAND", "75"},
  max_demand: {:system, "EB_PG_MAX_DEMAND", "100"},
  pool_size: {:system, "EB_PG_POOL_SIZE", "1"},
  buffer_size: {:system, "EB_PG_BUFFER_SIZE", "200"},
  topics: {:system, "EB_PG_TOPICS", ".*"},
  default_ttl_in_ms: {:system, "EB_PG_DEFAULT_TTL_IN_MS", "900000"},
  deletion_period_in_ms: {:system, "EB_PG_DELETION_PERIOD_IN_MS", "600000"}

import_config "#{Mix.env()}.exs"
