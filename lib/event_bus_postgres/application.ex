defmodule EventBus.Postgres.Application do
  @moduledoc """
  The EventBus.Postgres Application Service.

  The event_bus_postgres system business domain lives in this application.

  Exposes API to clients such as the `EventhubWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application
  alias EventBus.Postgres.Repo
  alias EventBus.Postgres.Config
  alias EventBus.Postgres.Supervisor.TTL, as: TTLSupervisor
  alias EventBus.Postgres.Supervisor.Bucket, as: BucketSupervisor
  alias EventBus.Postgres.Worker.Bucket, as: BucketWorker

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    link =
      Supervisor.start_link([
        supervisor(Repo, [], id: make_ref(), restart: :permanent),
        supervisor(BucketSupervisor, [], id: make_ref(), restart: :permanent),
        supervisor(TTLSupervisor, [], id: make_ref(), restart: :permanent),
      ], strategy: :one_for_one, name: EventBus.Postgres.Supervisor)

    if Config.enabled?() do
      EventBus.subscribe({BucketWorker, Config.topics()})
    end

    link
  end
end
