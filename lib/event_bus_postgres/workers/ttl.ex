defmodule EventBus.Postgres.Worker.TTL do
  @moduledoc """
  Worker for EventBucket
  """

  use GenServer
  alias EventBus.Postgres.{Config, Store}

  ## Callbacks

  @doc false
  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init(_opts) do
    delete_later()
    {:ok, nil}
  end

  @doc false
  def handle_info(:delete_expired, state) do
    Store.delete_expired()
    delete_later()
    {:noreply, state}
  end

  defp delete_later,
    do: Process.send_after(self(), :delete_expired, Config.deletion_period())
end
