# EventBus.Postgres

Listen and save `event_bus` events to Postgres.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `event_bus_postgres` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:event_bus_postgres, "~> 0.1.0-beta3"}
  ]
end
```

On the command line:

```shell
mix ecto.create -r EventBus.Postgres.Repo
mix ecto.migrate -r EventBus.Postgres.Repo
```

## Configuration

In your config.exs (or dev.exs, test.exs, prod.exs);

```elixir
config :event_bus_postgres,
  enabled: {:system, "EB_POSTGRES_ENABLED", "true"},
  persist_in_ms: {:system, "EB_POSTGRES_PERSIST_IN_MS", "100"},
  topics: {:system, "EB_POSTGRES_TOPICS", ".*"}, # seperator is ';'
  default_ttl: {:system, "EB_POSTGRES_DEFAULT_TTL", "900000"},
  deletion_period: {:system, "EB_POSTGRES_DELETION_PERIOD", "600000"}

# DB config
config :event_bus_postgres, EventBus.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2"),
  ssl: true

```

## Documentation

Module docs can be found at [https://hexdocs.pm/event_bus_postgres](https://hexdocs.pm/event_bus_postgres).

## Contributing

### Issues, Bugs, Documentation, Enhancements

1. Fork the project

2. Make your improvements and write your tests(make sure you covered all the cases).

3. Make a pull request.

## License

MIT

Copyright (c) 2018 Mustafa Turan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
