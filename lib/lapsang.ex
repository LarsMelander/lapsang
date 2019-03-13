defmodule Lapsang do
  use Request
  
  @moduledoc """
  Documentation for Lapsang.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lapsang.hello()
      :world

  """
  def hello do
    :world
  end

  def connect(host, port) do
    case Socket.TCP.connect(host, port) do
      {:ok, port} -> port
      {:error, error} -> error
    end
  end


end
