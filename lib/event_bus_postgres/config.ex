defmodule EventBus.Postgres.Config do
  @moduledoc """
  Config reader
  """

  @app :event_bus_postgres

  def enabled? do
    @app
    |> Application.get_env(:enabled)
    |> get_env_var()
    |> to_bool()
  end

  def auto_delete_with_ttl? do
    @app
    |> Application.get_env(:auto_delete_with_ttl, true)
    |> get_env_var()
    |> to_bool()
  end

  def pool_size do
    @app
    |> Application.get_env(:pool_size)
    |> get_env_var()
    |> to_int()
  end

  def buffer_size do
    @app
    |> Application.get_env(:buffer_size)
    |> get_env_var()
    |> to_int()
  end

  def min_demand do
    @app
    |> Application.get_env(:min_demand)
    |> get_env_var()
    |> to_int()
  end

  def max_demand do
    @app
    |> Application.get_env(:max_demand)
    |> get_env_var()
    |> to_int()
  end

  def topics do
    @app
    |> Application.get_env(:topics)
    |> get_env_var()
    |> to_list()
  end

  def default_ttl do
    @app
    |> Application.get_env(:default_ttl_in_ms)
    |> get_env_var()
    |> to_int()
    |> to_microseconds()
  end

  def deletion_period do
    @app
    |> Application.get_env(:deletion_period_in_ms)
    |> get_env_var()
    |> to_int()
  end

  defp get_env_var({:system, name, default}),
    do: System.get_env(name) || default

  defp get_env_var(item), do: item

  defp to_list(val) when is_list(val), do: val
  defp to_list(val), do: String.split(val, ";")

  defp to_int(val \\ 0), do: String.to_integer("#{val}")

  defp to_microseconds(val), do: val * 1_000

  defp to_bool(val) do
    case "#{val}" do
      "1" ->
        true

      "true" ->
        true

      true ->
        true

      _ ->
        false
    end
  end
end
