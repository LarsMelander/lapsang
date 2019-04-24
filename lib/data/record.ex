defmodule Lapsang.Record do
  defstruct(
    class_id: nil,
    record_type: nil,
    cluster: nil,
    position: nil,
    version: nil,
    rid: nil,
    o_class: nil,
    o_data: []
  )
end
