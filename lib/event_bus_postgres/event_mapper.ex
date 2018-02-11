defmodule EventBus.Postgres.EventMapper do
  @moduledoc """
  Mapper for EventBus events to Postgres scheme
  """

  use GenStage
  alias EventBus.Postgres.{Config, Queue, Model.Event}

  def init(state) do
    {
      :producer_consumer,
      state,
      subscribe_to: [
        {
          Queue,
          min_demand: Config.min_demand(), max_demand: Config.max_demand()
        }
      ],
      buffer_size: Config.buffer_size()
    }
  end

  def start_link(state \\ []) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def handle_events(event_shadows, _from, state) do
    events =
      Enum.map(event_shadows, fn {topic, id} ->
        event = EventBus.fetch_event({topic, id})
        EventBus.mark_as_completed({__MODULE__, topic, id})
        Event.from_eb_event(event)
      end)

    {:noreply, events, state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
