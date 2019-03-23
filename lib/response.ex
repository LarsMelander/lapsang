defmodule Response do

  @spec read(port) :: {:ok, binary} | {:error, atom}
  def read(socket) do
    case :gen_tcp.recv(socket, 0, 10000) do
      {:ok, packet} ->
        {:ok, packet <> readmore(socket)}
      {:error, message} ->
        {:error, message}
    end
  end

  defp readmore(socket) do
    case :gen_tcp.recv(socket, 0, 10) do
      {:ok, packet} ->
        packet <> readmore(socket)
      _ ->
        <<>>
    end
  end

  @spec decode_error(binary) :: {String.t, String.t}
  def decode_error(packet) do
    {_session_id, rest} = Decode.int(packet)
    # IO.puts "Session id: #{session_id}"
    {_, rest} = Decode.byte(rest)
    {exception, rest} = Decode.string(rest)
    # IO.puts "Exception: " <> exception
    {exception_message, _rest} = Decode.string(rest)
    # IO.puts "Exception message: " <> exception_message
    # {byte, rest} = Decode.byte(rest)
    # IO.puts "Byte: #{byte}"
    # IO.puts "Size: #{byte_size(rest)}"
    {exception, exception_message}
  end

end
