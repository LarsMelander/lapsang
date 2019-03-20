defmodule Decode do

  @spec short(<<_::16>>) :: integer
  def short(<<short :: signed-big-integer-16, _rest :: binary>>) do
    short
  end

  @spec int(<<_::32>>) :: integer
  def int(<<int :: signed-big-integer-32, _rest :: binary>>) do
    int
  end

  # @spec string(binary) :: String.t
  # def string(string) do
  #   (String.length(string) |> int) <> string
  # end

  @spec boolean(<<_::8>>) :: boolean
  def boolean(<<1>>), do: true
  def boolean(<<0>>), do: false

end
