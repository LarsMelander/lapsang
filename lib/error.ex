defmodule Lapsang.Error do

  @spec get(atom, String.t) :: {:error, String.t}
  def get(error, message) do
    { :error,
      case error do
        :connect_error ->
          "Connecting to server returned an error: #{message}"
        :protocol_error ->
          "Retrieving protocol returned an error: #{message}"
        :login_error ->
          "Login returned an error: #{message}"
        :login_response_error ->
          "Could not receive login response: #{message}"
        :decode_login_error ->
          message
        :open_error ->
          "Opening database returned error: #{message}"
        :open_response_error ->
          "Could not receive response: #{message}"
        :decode_open_error ->
          message
      end
    }
  end

end
