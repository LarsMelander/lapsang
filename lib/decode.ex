defmodule Decode do

  @spec byte(binary) :: {integer, binary}
  def byte(<<byte::8, rest::binary>>), do: {byte, rest}

  @spec short(binary) :: {integer, binary}
  def short(<<short::signed-big-integer-16, rest::binary>>), do: {short, rest}

  @spec int(binary) :: {integer, binary}
  def int(<<int::signed-big-integer-32, rest::binary>>), do: {int, rest}

  @spec bytelist(binary) :: {binary, binary}
  def bytelist(<<length::signed-big-integer-32, byte_list::binary>>) do
    { :binary.part(byte_list, 0, length),
      :binary.part(byte_list, length, byte_size(byte_list) - length)
    }
  end

  @spec string(binary) :: {String.t, binary}
  def string(byte_list) do
    {string, rest} = bytelist(byte_list)
    {to_string(string), rest}
  end

  @spec boolean(binary) :: {boolean, binary}
  def boolean(<<1, rest::binary>>), do: {true, rest}
  def boolean(<<0, rest::binary>>), do: {false, rest}

end
