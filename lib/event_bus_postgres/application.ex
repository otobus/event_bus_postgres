defmodule EventBus.Postgres.Application do
  @moduledoc false

  use Application
  alias EventBus.Postgres
  alias EventBus.Postgres.{Config, Repo, Queue, EventMapper, Bucket}
  alias EventBus.Postgres.Supervisor.TTL, as: TTLSupervisor

  def start(_type, _args) do
    link =
      Supervisor.start_link(
        workers(),
        strategy: :one_for_one,
        name: EventBus.Postgres.Supervisor
      )

    if Config.enabled?() do
      EventBus.subscribe({Postgres, Config.topics()})
    end

    link
  end

  defp workers do
    import Supervisor.Spec, warn: false

    [
      supervisor(Repo, [], id: make_ref(), restart: :permanent),
      supervisor(TTLSupervisor, [], id: make_ref(), restart: :permanent),
      worker(Queue, [], id: make_ref(), restart: :permanent),
      worker(EventMapper, [], id: make_ref(), restart: :permanent)
    ] ++ bucket_workers()
  end

  defp bucket_workers do
    import Supervisor.Spec, warn: false

    Enum.map(1..Config.pool_size(), fn _ ->
      worker(Bucket, [], id: make_ref(), restart: :permanent)
    end)
  end
end
