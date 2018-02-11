defmodule EventBus.Postgres.Repo do
  use Ecto.Repo, otp_app: :event_bus_postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("EB_PG_DATABASE_URL"))}
  end
end
