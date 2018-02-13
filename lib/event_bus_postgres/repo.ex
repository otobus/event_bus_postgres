defmodule EventBus.Postgres.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :event_bus_postgres

  @doc false
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("EB_PG_DATABASE_URL"))}
  end
end
