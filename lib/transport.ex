defmodule Transport do
  defstruct user: nil, password: nil,
    socket: nil, address: nil, port: nil,
    protocol_version: nil,
    serialization_type: "ORecordDocument2csv",
    driver_name: "OrientDB Elixir client",
    client_id: nil,
    session_id: -1
end
