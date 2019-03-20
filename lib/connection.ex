defmodule Connection do
  defstruct user: nil, password: nil,
    socket: nil, address: nil, port: nil,
    protocol_version: nil,
    serialization_type: "ORecordDocument2csv",
    driver_name: "OrientDB Elixir client",
    session_id: -1
end
