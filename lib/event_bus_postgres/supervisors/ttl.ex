defmodule EventBus.Postgres.Supervisor.TTL do
  @moduledoc """
  A supervisor for Event TTL
  """

  use Supervisor
  alias EventBus.Postgres.Worker.TTL, as: TTLWorker

  @doc false
  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(TTLWorker, [], id: make_ref(), restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
