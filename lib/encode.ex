defmodule Encode do

  @spec short(integer) :: <<_::16>>
  def short(short), do: <<short :: 16>>

  @spec int(integer) :: <<_::32>>
  def int(int), do: <<int :: 32>>

  @spec string(String.t) :: binary
  def string(string) do
    (String.length(string) |> int) <> string
  end

  @spec boolean(boolean) :: <<_::8>>
  def boolean(true), do: <<1>>
  def boolean(false), do: <<0>>

end
