defmodule Lapsang.Query do

  @spec create_vertex_query(String.t, [{atom, String.t}]) :: String.t
  def create_vertex_query(class, list) do
    "CREATE VERTEX #{class}" <> get_params(list)
  end

  defp get_params([]), do: ""
  defp get_params(list) do
    (for {key, value} <- list, do: " #{key} = '#{value}'")
      |> Enum.join(",")
      |> (&(" SET" <> &1)).()
  end

end
