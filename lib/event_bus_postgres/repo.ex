defmodule EventBus.Postgres.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :event_bus_postgres,
    adapter: Ecto.Adapters.Postgres

  alias EventBus.Postgres.Config

  @doc false
  def init(_, opts) do
    opts =
      opts
      |> merge_db_url()
      |> merge_pool_size()

    {:ok, opts}
  end

  defp merge_db_url(opts) do
    case Keyword.has_key?(opts, :url) do
      false -> merge_val(opts, :url, Config.db_url())

      true -> opts
    end
  end

  defp merge_pool_size(opts) do
    case Keyword.has_key?(opts, :pool_size) do
      false -> merge_val(opts, :pool_size, Config.db_pool_size())

      true -> opts
    end
  end

  defp merge_val(opts, _key, nil) do
    opts
  end

  defp merge_val(opts, key, val) do
    Keyword.put(opts, key, val)
  end
end
