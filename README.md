# EventBus.Postgres

Listen and save `event_bus` events to Postgres.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `event_bus_postgres` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:event_bus_postgres, "~> 0.2"}
  ]
end
```

On the command line:

```shell
mix deps.get
cp _deps/event_bus_postgres/priv/repo/migrations/* priv/repo/migrations/
mix ecto.create -r EventBus.Postgres.Repo
mix ecto.migrate -r EventBus.Postgres.Repo
```

## Configuration

In your config.exs (or dev.exs, test.exs, prod.exs);

```elixir
config :event_bus_postgres,
  enabled: {:system, "EB_PG_ENABLED", "true"},
  min_demand: {:system, "EB_PG_MIN_DEMAND", "75"}, # GenStage consumer
  max_demand: {:system, "EB_PG_MAX_DEMAND", "100"}, # GenStage consumer
  pool_size: {:system, "EB_PG_POOL_SIZE", "1"}, # GenStage consumer
  buffer_size: {:system, "EB_PG_BUFFER_SIZE", "200"}, # GenStage producer_consumer
  topics: {:system, "EB_PG_TOPICS", ".*"},
  default_ttl_in_ms: {:system, "EB_PG_DEFAULT_TTL_IN_MS", "900000"},
  deletion_period_in_ms: {:system, "EB_PG_DELETION_PERIOD_IN_MS", "600000"}

# DB config
config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("EB_PG_DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("EB_PG_POOL_SIZE") || "1"),
  ssl: true

```

## Documentation

Module docs can be found at [https://hexdocs.pm/event_bus_postgres](https://hexdocs.pm/event_bus_postgres).

## Contributing

### Issues, Bugs, Documentation, Enhancements

1. Fork the project

2. Make your improvements and write your tests(make sure you covered all the cases).

3. Make a pull request.

## Demo

Let's create 100k rows of events in Postgres with 1 worker

```shell
export EB_PG_ENABLED=true;
export EB_PG_MIN_DEMAND=75;
export EB_PG_MAX_DEMAND=100;
export EB_PG_POOL_SIZE=1; # 1 worker/consumer
export EB_PG_BUFFER_SIZE=200;
export EB_PG_TOPICS=".*";
export EB_PG_DEFAULT_TTL="900000";
export EB_PG_DELETION_PERIOD="600000";
iex -S mix;
```

In the app console:

```elixir
use EventBus.EventSource
topic = :fake_event_initialized
error_topic = :fake_event_erred
EventBus.register_topic(topic)
EventBus.register_topic(error_topic)
source = "console"
ttl = 600_000_000

transaction_id = UUID.uuid4()

result = :timer.tc(fn ->
  Enum.each(1..100_000, fn _ ->
    params = %{id: UUID.uuid4(), topic: topic, transaction_id: transaction_id, ttl: ttl, source: source, error_topic: error_topic}
    EventSource.notify(params) do
      "this is a fake event"
    end
  end)
end)
```

## License

MIT

Copyright (c) 2018 Mustafa Turan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
