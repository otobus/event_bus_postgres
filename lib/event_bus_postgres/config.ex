defmodule EventBus.Postgres.Config do
  @moduledoc """
  Config reader
  """

  @app :event_bus_postgres

  ##############################################################################
  # POSTGRES DB CONFIG START
  ##############################################################################

  @spec db_url() :: String.t() | nil
  def db_url do
    @app
    |> Application.get_env(:db_url)
    |> get_env_var()
  end

  @spec db_pool_size() :: integer() | nil
  def db_pool_size do
    @app
    |> Application.get_env(:db_pool_size)
    |> get_env_var()
    |> to_int()
  end

  ##############################################################################
  # POSTGRES DB CONFIG END
  ##############################################################################

  @spec enabled?() :: boolean()
  def enabled? do
    @app
    |> Application.get_env(:enabled)
    |> get_env_var()
    |> to_bool()
  end

  @spec auto_delete_with_ttl?() :: boolean()
  def auto_delete_with_ttl? do
    @app
    |> Application.get_env(:auto_delete_with_ttl, true)
    |> get_env_var()
    |> to_bool()
  end

  @spec pool_size() :: integer()
  def pool_size do
    @app
    |> Application.get_env(:pool_size, 1)
    |> get_env_var()
    |> to_int()
  end

  @spec buffer_size() :: integer()
  def buffer_size do
    @app
    |> Application.get_env(:buffer_size, 200)
    |> get_env_var()
    |> to_int()
  end

  @spec min_demand() :: integer()
  def min_demand do
    @app
    |> Application.get_env(:min_demand, 75)
    |> get_env_var()
    |> to_int()
  end

  @spec max_demand() :: integer()
  def max_demand do
    @app
    |> Application.get_env(:max_demand, 100)
    |> get_env_var()
    |> to_int()
  end

  @spec topics() :: list(String.t())
  def topics do
    @app
    |> Application.get_env(:topics, "")
    |> get_env_var()
    |> to_list()
  end

  @spec default_ttl() :: integer()
  def default_ttl do
    @app
    |> Application.get_env(:default_ttl_in_ms, 900_000)
    |> get_env_var()
    |> to_int()
    |> to_microseconds()
  end

  @spec deletion_period() :: integer()
  def deletion_period do
    @app
    |> Application.get_env(:deletion_period_in_ms, default_ttl())
    |> get_env_var()
    |> to_int()
  end

  defp get_env_var({:system, name, default}) do
    System.get_env(name) || default
  end

  defp get_env_var(item) do
    item
  end

  defp to_list(val) when is_list(val) do
    val
  end

  defp to_list(val) do
    String.split(val, ";")
  end

  defp to_int(val) when is_integer(val) do
    val
  end

  defp to_int(val) do
    String.to_integer(val)
  end

  defp to_microseconds(val) do
    val * 1_000
  end

  defp to_bool(val) do
    case "#{val}" do
      "1" ->
        true

      "true" ->
        true

      _ ->
        false
    end
  end
end
