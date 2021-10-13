# EventBus.Postgres

Listen and save `event_bus` events to Postgres.

## Installation

The package can be installed by adding `event_bus_postgres` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:event_bus_postgres, "~> 0.4.3"},
    {:event_bus, "~> 1.6"}
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
  # Enable/disable PG consumer
  enabled: {:system, "EB_PG_ENABLED", "true"},

  # If you want to disable auto delete set auto_delete_with_ttl to "false"
  auto_delete_with_ttl: {:system, "EB_PG_AUTO_DELETE_WITH_TTL", "true"},

  # Default TTL for deletion, this value will be set when not given in Event struct
  default_ttl_in_ms: {:system, "EB_PG_DEFAULT_TTL_IN_MS", "900000"},

  # Execute delete in given period
  deletion_period_in_ms: {:system, "EB_PG_DELETION_PERIOD_IN_MS", "600000"},

  # GenStage config
  min_demand: {:system, "EB_PG_MIN_DEMAND", "75"}, # GenStage consumer
  max_demand: {:system, "EB_PG_MAX_DEMAND", "100"}, # GenStage consumer
  pool_size: {:system, "EB_PG_POOL_SIZE", "1"}, # GenStage consumer + DB Connection pool
  buffer_size: {:system, "EB_PG_BUFFER_SIZE", "200"}, # GenStage producer_consumer

  # Topic subscriptions seperated by semicolons ';'
  topics: {:system, "EB_PG_TOPICS", ".*"},

  # Set DB url and pool size in here if you use Elixir releases
  db_url: {:system, "EB_PG_DATABASE_URL", nil},
  db_pool_size: {:system, "EB_PG_DATABASE_POOL_SIZE", 1}

# Regular ecto DB config
config :event_bus_postgres, ecto_repos: [EventBus.Postgres.Repo]

config :event_bus_postgres, EventBus.Postgres.Repo,
  # ...,
  # Set other configs depending on your DB needs
  adapter: Ecto.Adapters.Postgres,
  ssl: true # depending on your need
```

## How does it work?

```markdown
+-----+
|     |                                         GEN STAGE
|     |        EVENTBUS      +------------------------------------------+
|     |        CONSUMER      |                   +---+                  |
|     |        +-----+       |                   |   |                  |
|     |        |     |       |                   |   |          +---+   |
|     |        |  E  |       |                   |   |          |   |   |
|     |        |  v  |       |                   |   |          |   |   |
|     |        |  e  |       |                   |   |          |   |   |
|  E  |        |  n  |       |                   | E |          |   |   |
|  l  |        |  t  |       |  +-------+        | v |          |   |   |
|  i  | topic  |  B  |  topic   |       |        | e |          |   |
|  x  |   +    |  u  |    +     |   Q   |        | n |          | B |       +--+
|  i  |event_id|  s  | event_id |   u   |   ask  | t |    ask   | u |       |  |
|  r  |------->|  .  |--------->|   e   |<-------|   | <--------| c | BATCH |  |
|     |        |  P  |          |   u   |------->| M | -------->| k |------>|DB|
|  E  |        |  o  |          |   e   |   pull | a |    pull  | e | INSERT|  |
|  v  |        |  s  |          |       |        | p |          | t |       |  |
|  e  |        |  t  |       |  +-------+        | p |          |   |   |   +--+
|  n  |        |  g  |       |  GENSTAGE         | e |          |   |   |
|  t  |        |  r  |       |  PRODUCER         | r |          |   |   |
|  B  |        |  e  |       |                   |   |          |   |   |
|  u  |        |  s  |       |                   |   |          |   |   |
|  s  |        +-----+       |                   |   |          |   |   |
|     |<-----------------------------------------|   |          +---+   |
|     |                      |    fetch_event/1  |   |         CONSUMER |
|     |                      |                   |   |                  |
+-----+                      |                   +---+                  |
                             |                  CONSUMER                |
                             |                  PRODUCER                |
                             +------------------------------------------+
```

## Documentation

Module docs can be found at [https://hexdocs.pm/event_bus_postgres](https://hexdocs.pm/event_bus_postgres).

## Contributing

### Issues, Bugs, Documentation, Enhancements

1. Fork the project

2. Make your improvements and write your tests(make sure you covered all the cases).

3. Make a pull request.

### Contributors

Special thanks to all [contributors](https://github.com/otobus/event_bus_postgres/graphs/contributors).

## Demo

Let's create 100k rows of events in Postgres with 1 worker

```shell
# Export ENV vars for event_bus_postgres configurations

export EB_PG_ENABLED=true;
export EB_PG_MIN_DEMAND=75;
export EB_PG_MAX_DEMAND=100;
export EB_PG_POOL_SIZE=1; # 1 worker
export EB_PG_BUFFER_SIZE=200;
export EB_PG_TOPICS=".*";
export EB_PG_DEFAULT_TTL="900000";
export EB_PG_DELETION_PERIOD="600000";

# Export ENV vars for Postgres db
export EB_PG_DATABASE_URL=postgres://admin:123456@localhost:5432/event_bus_postgres_dev
export EB_PG_DATABASE_POOL_SIZE=1 # 1 DB connection

iex -S mix;
```

In the app console:

```elixir
defmodule FakeSource do
  @moduledoc """
  Fake event generator
  """

  use EventBus.EventSource

  @doc """
  Generates 100_000 events
  """
  def generate_events do
    topic = :fake_event_initialized
    error_topic = :fake_event_erred
    EventBus.register_topic(topic)
    EventBus.register_topic(error_topic)
    source = "console"
    ttl = 600_000_000

    transaction_id = UUID.uuid4()

    :timer.tc(fn ->
      Enum.each(1..100_000, fn _ ->
        params = %{id: UUID.uuid4(), topic: topic, transaction_id: transaction_id, ttl: ttl, source: source, error_topic: error_topic}
        EventSource.notify(params) do
          "this is a fake event with id #{params[:id]}"
        end
      end)
    end)
  end
end

# All generated events will be saved to postgres automatically
{time_spent, :ok} = FakeSource.generate_events()
```

## Code of Conduct

Please refer to [code of conduct](CODE_OF_CONDUCT.md) file.

## License

[MIT](MIT_LICENSE.md), [LCR](LCR_LICENSE.md)

Copyright (c) 2018 Mustafa Turan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
