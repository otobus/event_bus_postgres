defmodule EventBus.Postgres.Worker.Bucket do
  @moduledoc """
  Worker for Event Bucket
  """

  use GenServer
  alias EventBus.Postgres.{Config, Store, Model.Event}

  ## Public api

  @doc """
  Process event
  """
  def process({_topic, _id} = event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  @doc false
  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init(_opts) do
    persist_later()
    {:ok, []}
  end

  ## Callbacks

  @doc false
  def handle_cast({topic, id}, state) do
    event    = EventBus.fetch_event({topic, id})
    db_event = Event.from_eb_event(event)
    EventBus.mark_as_completed({__MODULE__, topic, id})
    {:noreply, [db_event | state]}
  end

  @doc false
  def handle_info(:persist, state) do
    Store.batch_insert(state)
    persist_later()
    {:noreply, []}
  end

  defp persist_later,
    do: Process.send_after(self(), :persist, Config.persist_in_ms())
end
