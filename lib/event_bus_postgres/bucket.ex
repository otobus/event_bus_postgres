defmodule EventBus.Postgres.Bucket do
  @moduledoc """
  Event persistence worker
  """

  use GenStage
  alias EventBus.Postgres.{Config, EventMapper, Store}

  def init(:ok) do
    {
      :consumer,
      :ok,
      subscribe_to: [
        {
          EventMapper,
          min_demand: Config.min_demand(), max_demand: Config.max_demand()
        }
      ]
    }
  end

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  @doc false
  def handle_events(events, _from, state) do
    Store.batch_insert(events)
    {:noreply, [], state}
  end
end
