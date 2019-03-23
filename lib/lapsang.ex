defmodule Lapsang do

  alias Lapsang.Connect

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

  @spec connect(any, integer) :: {:ok, %Transport{}} | {:error, String.t}
  def connect(address \\ {127, 0, 0, 1}, port \\ 2424) do
    Connect.connect(address, port)
  end

  @spec login(%Transport{}, String.t, String.t) :: {:ok, %Transport{}} | {:error, String.t}
  def login(transport, user, password) do
    Connect.login(transport, user, password)
  end

  def db_exist do

  end

  def db_create do

  end

  def db_open do

  end

  def db_reopen do

  end

  def db_close do

  end

  def command do

  end

  def tx_commit do
    
  end

  def create_vertex do

  end

end
