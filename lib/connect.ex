defmodule Lapsang.Connect do

  alias Lapsang.Transport
  alias Lapsang.Request
  alias Lapsang.Response
  alias Lapsang.Error

  @spec connect(any, integer) :: {:ok, %Transport{}} | {:error, String.t}
  def connect(address, port) do
    try do
      { :ok,
        %Transport{address: convert_address(address),
                    port: port, client_id: Request.create_client_id()}
          |> connect_to_server
          |> eval_protocol
      }
    catch
      {error, message} ->
        Error.get(error, message)
    end
  end

  defp convert_address("localhost"), do: {127, 0, 0, 1}
  defp convert_address({_, _, _, _} = address), do: address
  defp convert_address(address) do
    String.split(address, ".")
      |> Enum.map(&(String.to_integer &1))
      |> List.to_tuple
  end

  defp connect_to_server(transport) do
    case :gen_tcp.connect(transport.address,
                          transport.port,
                          [:binary, active: false]) do
      {:ok, socket} -> %{transport | socket: socket}
      {:error, message} -> throw {:connect_error, message}
    end
  end

  defp eval_protocol(transport) do
    case Response.read(transport.socket) do
      {:ok, packet} ->
        {version, _} = Decode.short(packet)
        %{transport | protocol_version: version}
      {:error, message} ->
        throw {:protocol_error, message}
    end
  end

  @spec login(%Transport{}) :: {:ok, %Transport{}} | {:error, String.t}
  def login(transport) do
    try do
      { :ok,
        send_login(transport)
          |> login_response
      }
    catch
      {error, message} ->
        Error.get(error, message)
    end
  end

  defp send_login(transport) do
    case :gen_tcp.send(transport.socket, Request.build_connect(transport)) do
      :ok -> transport
      {:error, message} -> throw {:login_error, message}
    end
  end

  defp login_response(transport) do
    case Response.read(transport.socket) do
      {:ok, packet} ->
        decode_login(transport, packet)
      {:error, message} ->
        throw {:login_response_error, message}
    end
  end

  defp decode_login(transport, <<0::8, packet::binary>>) do
    {old_session_id, new_session_id, _rest} = Response.get_session_id(packet)
    %{transport | old_session_id: old_session_id, session_id: new_session_id}
  end
  defp decode_login(_transport, <<1::8, packet::binary>>) do
    {exception, exception_message} = Response.decode_error(packet)
    throw {:decode_login_error, "Exception: #{exception}: #{exception_message}"}
  end

end
