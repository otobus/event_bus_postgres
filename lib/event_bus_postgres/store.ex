defmodule EventBus.Postgres.Store do
  @moduledoc """
  Basic db functions for EventBus.Postgres
  """

  import Ecto.Query
  alias EventBus.Postgres.{Repo, Model.Event}

  @doc """
  Fetch all events with pagination
  """
  def all(
        %{page: page, per_page: per_page, since: since} \\ %{
          page: 1,
          per_page: 20,
          since: 0
        }
      ) do
    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since,
        offset: ^((page - 1) * per_page),
        limit: ^per_page
      )

    query
    |> Repo.all()
    |> Enum.map(fn event -> Event.to_eb_event(event) end)
  end

  @doc """
  Total events per topic since given time
  """
  def count_per_topic(%{since: since} \\ %{since: 0}) do
    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since
      )

    Repo.aggregate(query, :count, :topic)
  end

  @doc """
  Total events since given time
  """
  def count(%{since: since} \\ %{since: 0}) do
    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since
      )

    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Fetch all events with pagination
  """
  def find_all_by_transaction_id(
        %{
          page: page,
          per_page: per_page,
          since: since,
          transaction_id: transaction_id
        } \\ %{
          page: 1,
          per_page: 20,
          since: 0,
          transaction_id: nil
        }
      ) do
    query =
      from(
        e in Event,
        where: e.transaction_id == ^transaction_id and e.occurred_at >= ^since,
        offset: ^((page - 1) * per_page),
        limit: ^per_page
      )

    query
    |> Repo.all()
    |> Enum.map(fn event -> Event.to_eb_event(event) end)
  end

  @doc """
  Find an event
  """
  def find(id) do
    case Repo.get(id, Event) do
      nil -> nil
      event -> Event.to_eb_event(event)
    end
  end

  @doc """
  Delete an event
  """
  def delete(id) do
    Repo.delete(%Event{id: id})
  end

  @doc """
  Batch insert
  """
  def batch_insert([]), do: :ok

  def batch_insert(events),
    do: Repo.insert_all(Event, events, on_conflict: :nothing)

  @doc """
  Delete expired events
  """
  def delete_expired do
    now = System.os_time(:micro_seconds)

    query =
      from(
        e in Event,
        where: fragment("? + ? >= ?", e.occurred_at, e.ttl, ^now)
      )

    Repo.delete_all(query)
  end
end
