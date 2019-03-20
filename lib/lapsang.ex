defmodule Lapsang do
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

  @spec connect(any, integer) :: {:ok, %Connection{}} | {:error, String.t}
  def connect(address \\ {127, 0, 0, 1}, port \\ 2424) do
    try do
      {:ok, %Connection{address: convert_address(address), port: port}
              |> connect_to_server
              |> eval_protocol
      }
    catch
      {:connect_error, message} ->
        {:error, "Connecting to server returned an error: #{message}"}
      {:protocol_error, message} ->
        {:error, "Retrieving protocol returned an error: #{message}"}
    end
  end

  defp convert_address("localhost"), do: {127, 0, 0, 1}
  defp convert_address({_, _, _, _} = address), do: address
  defp convert_address(address) do
    String.split(address, ".")
      |> Enum.map(&(String.to_integer &1))
      |> List.to_tuple
  end

  defp connect_to_server(connection) do
    case :gen_tcp.connect(connection.address,
                          connection.port,
                          [:binary, active: false]) do
      {:ok, socket} -> %{connection | socket: socket}
      {:error, message} -> throw {:connect_error, message}
    end
  end

  defp eval_protocol(connection) do
    case :gen_tcp.recv(connection.socket, 0) do
      {:ok, packet} ->
        %{connection | protocol_version: Decode.short(packet)}
      {:error, message} ->
        throw {:protocol_error, message}
    end
  end

  @spec login(%Connection{}, String.t, String.t)
    :: {:ok, %Connection{}} | {:error, String.t}
  def login(connection, user, password) do
    try do
      {:ok, %{connection | user: user, password: password}
              |> send_login
              |> login_response
      }
    catch
      {:login_error, message} ->
        {:error, "Login returned an error: #{message}"}
      {:login_response_error, message} ->
        {:error, "Could not receive login response: #{message}"}
    end
  end

  defp send_login(connection) do
    case :gen_tcp.send(connection.socket, Request.build_connect(connection)) do
      :ok -> connection
      {:error, message} -> throw {:login_error, message}
    end
  end

  defp login_response(connection) do
    case :gen_tcp.recv(connection.socket, 0) do
      {:ok, packet} ->
        %{connection | session_id: Decode.int(packet)}
      {:error, message} ->
        throw {:login_response_error, message}
    end
  end

end
