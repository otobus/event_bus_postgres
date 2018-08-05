defmodule EventBus.Postgres.Model.Event do
  @moduledoc """
  Event model/struct
  """

  use Ecto.Schema

  alias EventBus.Postgres.{Config, Model.Event}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field(:data, :binary)
    field(:initialized_at, :integer)
    field(:occurred_at, :integer)
    field(:source, :string)
    field(:topic, :string)
    field(:transaction_id, Ecto.UUID)
    field(:ttl, :integer)
  end

  @doc false
  def from_eb_event(%EventBus.Model.Event{} = event) do
    %{
      id: event.id,
      transaction_id: event.transaction_id,
      topic: "#{event.topic}",
      data: :erlang.term_to_binary(event.data),
      initialized_at: event.initialized_at,
      occurred_at: event.occurred_at || System.os_time(:micro_seconds),
      source: event.source,
      ttl: event.ttl || Config.default_ttl()
    }
  end

  @doc false
  def to_eb_event(%Event{} = event) do
    %EventBus.Model.Event{
      id: "#{event.id}",
      transaction_id: "#{event.transaction_id}",
      topic: :"#{event.topic}",
      data: :erlang.binary_to_term(event.data),
      initialized_at: event.initialized_at,
      occurred_at: event.occurred_at,
      source: event.source,
      ttl: event.ttl
    }
  end
end
