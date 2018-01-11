defmodule EventBus.Postgres.Supervisor.Bucket do
  @moduledoc """
  A supervisor for EventBucket
  """

  use Supervisor
  alias EventBus.Postgres.Worker.Bucket, as: BucketWorker

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(BucketWorker, [], id: make_ref(), restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
