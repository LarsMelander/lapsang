defmodule Lapsang.Database do

  alias Lapsang.Transport
  alias Lapsang.Record
  alias Lapsang.Request
  alias Lapsang.Response
  alias Lapsang.Error

  @spec open(%Transport{}) :: {:ok, %Transport{}} | {:error, String.t}
  def open(transport) do
    try do
      { :ok,
        send_open(transport)
          |> open_response
      }
    catch
      {error, message} ->
        Error.get(error, message)
    end
  end

  defp send_open(transport) do
    case :gen_tcp.send(transport.socket, Request.build_db_open(transport)) do
      :ok -> transport
      {:error, message} ->
        throw {:open_error, message}
    end
  end

  defp open_response(transport) do
    case Response.read(transport.socket) do
      {:ok, packet} ->
        decode_login(transport, packet)
      {:error, message} ->
        throw {:open_response_error, message}
    end
  end

  defp decode_login(transport, <<0::8, packet::binary>>) do
    {old_session_id, new_session_id, rest} = Response.get_session_id(packet)
    {_token, _rest} = Response.read_token(rest)
    # {clusters, _rest} = get_clusters(rest)
    %{transport | old_session_id: old_session_id, session_id: new_session_id#,
                  # db_clusters: clusters
                }
  end
  defp decode_login(_transport, <<1::8, packet::binary>>) do
    {exception, exception_message} = Response.decode_error(packet)
    throw {:decode_open_error, "Exception: #{exception}: #{exception_message}"}
  end

  # defp get_clusters(packet) do
  #   {cluster_count, rest} = Decode.short(packet)
  #   read_clusters(rest, cluster_count)
  # end

  # defp read_clusters(packet, 0), do: {[], packet}
  # defp read_clusters(packet, count) do
  #   {cluster_name, rest} = Decode.string(packet)
  #   {cluster_id, rest} = Decode.short(rest)
  #   {list, rest} = read_clusters(rest, count - 1)
  #   {[%{name: cluster_name, id: cluster_id} | list], rest}
  # end

  @spec db_command(String.t, %Transport{}, binary, String.t) :: :ok | {:error, atom}
  def db_command(query, transport, mode, class_name) do
    :gen_tcp.send(
      transport.socket,
      Request.build_db_command(transport, mode, class_name, query)
    )
  end

  @spec db_command_response(:ok | {:error, atom}, %Transport{}) :: any
  def db_command_response({:error, error}, _transport), do: {:error, error}
  def db_command_response(:ok, transport) do
    case Response.read(transport.socket) do
      {:ok, packet} ->
        decode_command_response(packet)
      {:error, error} ->
        {:error, error}
    end
  end

  defp decode_command_response(<<0::8, packet::binary>>) do
    {_session_id, rest} = Decode.int(packet)
    decode_records(rest)
  end
  defp decode_command_response(<<1::8, _packet::binary>>) do
    {:error, :error}
  end

  defp decode_records(<<?n::8, _packet::binary>>) do

  end
  defp decode_records(<<?r::8, packet::binary>>) do
    {class_id, rest} = Decode.short(packet)
    {record_type, rest} = Decode.byte(rest)
    {cluster, rest} = Decode.short(rest)
    {position, rest} = Decode.long(rest)
    {version, rest} = Decode.int(rest)
    {data, rest} = Decode.string(rest)
    {_0, _} = Decode.int(rest)

    %Record{
      class_id: class_id,
      record_type: record_type,
      cluster: cluster,
      position: position,
      version: version,
      rid: [cluster, position],

    }
  end
  defp decode_records(<<?l::8, _packet::binary>>) do

  end
  defp decode_records(<<?s::8, _packet::binary>>) do

  end
  defp decode_records(<<?w::8, _packet::binary>>) do

  end
  defp decode_records(<<?i::8, _packet::binary>>) do

  end

end
