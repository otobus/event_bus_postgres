defmodule EventBus.Postgres do
  @moduledoc """
  Postgres plugin for EventBus
  """

  alias EventBus.Postgres.Queue

  @doc """
  Deliver EventBus events to Postgres queue
  """
  def process({_topic, _id} = event_shadow) do
    Queue.push(event_shadow)
  end
end
