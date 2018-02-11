defmodule EventBus.Postgres do
  @moduledoc """
  Documentation for EventBus.Postgres.
  """

  alias EventBus.Postgres.Queue

  @doc """
  Deliver EventBus events to Postgres queue
  """
  def process({_topic, _id} = event_shadow) do
    Queue.push(event_shadow)
  end
end
