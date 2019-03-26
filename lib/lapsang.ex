defmodule Lapsang do

  alias Lapsang.Transport
  alias Lapsang.Connect
  alias Lapsang.Database

  @moduledoc """
  Documentation for Lapsang.
  """

  @spec connect(any, integer) :: {:ok, %Transport{}} | {:error, String.t}
  def connect(address \\ {127, 0, 0, 1}, port \\ 2424) do
    Connect.connect(address, port)
  end

  @spec login(%Transport{}, String.t, String.t) :: {:ok, %Transport{}} | {:error, String.t}
  def login(transport, user, password) do
    Connect.login(%{transport | user: user, password: password})
  end

  def db_exist do

  end

  def db_create do

  end

  @spec db_open(%Transport{}, String.t) :: {:ok, %Transport{}} | {:error, String.t}
  def db_open(transport, db_name) do
    Database.open(%{transport | db_name: db_name})
  end

  def db_reopen do

  end

  def db_close do

  end

  def command do

  end

  def tx_commit do

  end

  @spec create_vertex(%Transport{}, String.t, [{atom, String.t}]) :: any
  def create_vertex(transport, class, list \\ []) do
    query = Database.create_vertex_query(class, list)
    Database.db_command(transport, <<?a::8>>, "c", query)
  end

end
