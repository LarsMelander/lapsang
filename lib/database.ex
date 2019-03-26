defmodule Lapsang.Database do

  alias Lapsang.Transport
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
        {status, rest} = Decode.byte(packet)
        decode_login(transport, status, rest)
      {:error, message} ->
        throw {:open_response_error, message}
    end
  end

  defp decode_login(transport, 0, packet) do
    {old_session_id, new_session_id, rest} = Response.get_session_id(packet)
    {_token, _rest} = Response.read_token(rest)
    # {clusters, _rest} = get_clusters(rest)
    %{transport | old_session_id: old_session_id, session_id: new_session_id#,
                  # db_clusters: clusters
                }
  end
  defp decode_login(_transport, 1, packet) do
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

  @spec create_vertex_query(String.t, [{atom, String.t}]) :: String.t
  def create_vertex_query(class, list) do
    (for {key, value} <- list, do: "#{key} = '#{value}'")
      |> Enum.join(", ")
      |> get_query(class, list)
  end

  defp get_query(_params, class, []), do: "CREATE VERTEX #{class}"
  defp get_query(params, class, _), do: "CREATE VERTEX #{class} SET " <> params

  def db_command(transport, mode, class_name, query) do
    :gen_tcp.send(
      transport.socket,
      Request.build_db_command(transport, mode, class_name, query)
    )
  end
end
