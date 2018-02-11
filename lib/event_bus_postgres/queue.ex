defmodule EventBus.Postgres.Queue do
  @moduledoc """
  Postgres queue (producer)
  """

  use GenStage

  def init(state) do
    {:producer, state, buffer_size: :infinity}
  end

  def start_link(state \\ []) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Push event shadows to queue
  """
  @spec push({atom(), String.t() | integer()}) :: :ok
  def push({_topic, _id} = event_shadow) do
    GenServer.cast(__MODULE__, {:push, event_shadow})
  end

  @doc false
  def handle_cast({:push, event_shadow}, state) do
    {:noreply, [event_shadow], state}
  end

  @doc false
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
