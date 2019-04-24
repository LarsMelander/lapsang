defmodule Lapsang.Request do

  alias Lapsang.Transport

  # Server (CONNECT Operations)
  # @shutdown <<1>>  # Shut down server.
  @connect  <<2>>  # Required initial operation to access to server commands.
  @db_open  <<3>>  # Required initial operation to access to the database.
  # @db_create <<4>>  # Add a new database.
  # @db_exist <<6>>  # Check if database exists.
  @db_command <<41>> # Execute a command.

  @spec create_client_id() :: String.t
  def create_client_id() do
    {:ok, addr_list} = :inet.getifaddrs()
    {reg, _list} = Enum.find(addr_list, fn {_reg, list} ->
      list[:addr] != {127, 0, 0, 1}
    end)
    to_string(reg)
  end

  defp build_header(transport) do
    Encode.int(transport.session_id)
      <> Encode.string(transport.driver_name)
      <> Encode.string(Lapsang.MixProject.project[:version])
      <> Encode.short(Lapsang.MixProject.project[:protocol_version])
      <> Encode.string(transport.client_id)
      <> Encode.string(transport.serialization_type)
      <> Encode.boolean(false)
      <> Encode.boolean(true)
      <> Encode.boolean(true)
  end

  @spec build_connect(%Transport{}) :: binary
  def build_connect(transport) do
    @connect
      <> build_header(transport)
      <> Encode.string(transport.user)
      <> Encode.string(transport.password)
  end

  @spec build_db_open(%Transport{}) :: binary
  def build_db_open(transport) do
    @db_open
      <> build_header(transport)
      <> Encode.string(transport.db_name)
      <> Encode.string(transport.user)
      <> Encode.string(transport.password)
  end

  @spec build_db_command(%Transport{}, binary, String.t, String.t) :: binary
  def build_db_command(transport, mode, class_name, query) do
    chunk = Encode.string(class_name)
      <> Encode.string(query)
      <> Encode.int(0)
    @db_command
      <> Encode.int(transport.session_id)
      <> mode
      <> Encode.int(byte_size chunk)
      <> chunk
  end

        # DB_DROP:      <<7>>,  # Delete database.
        # CONFIG_GET:   <<70>>, # Get a configuration property.
        # CONFIG_SET:   <<71>>, # Set a configuration property.
        # CONFIG_LIST:  <<72>>, # Get a list of configuration properties.
        # DB_LIST:      <<74>>, # Get a list of databases.

        # # Database (DB_OPEN Operations)
        # DB_CLOSE:           <<5>>,  # Close a database.
        # DB_SIZE:            <<8>>,  # Get the size of a database (in bytes).
        # DB_COUNTRECORDS:    <<9>>,  # Get total number of records in a database.
        # DATACLUSTER_ADD:    <<10>>, # (Deprecated) Add a data cluster.
        # DATACLUSTER_DROP:   <<11>>, # (Deprecated) Delete a data cluster.
        # DATACLUSTER_COUNT:  <<12>>, # (Deprecated) Get the total number of data clusters.
        # DATACLUSTER_DATARANGE:  <<13>>, # (Deprecated) Get the data range of data clusters.
        # DATACLUSTER_COPY:       <<14>>, # Copy a data cluster.
        # DATACLUSTER_LH_CLUSTER_IS_USED: <<16>>,
        # RECORD_METADATA:    <<29>>, # Get metadata from a record.
        # RECORD_LOAD:        <<30>>, # Load a record.
        # RECORD_LOAD_IF_VERSION_NOT_LATEST:  <<44>>, # Load a record.
        # RECORD_CREATE:      <<31>>, # Add a record. (Asynchronous)
        # RECORD_UPDATE:      <<32>>, # (Asynchronous)
        # RECORD_DELETE:      <<33>>, # (Asynchronous) Delete a record.
        # RECORD_COPY:        <<34>>, # (Asynchronous) Copy a record.
        # RECORD_CLEAN_OUT:   <<38>>, # (Asynchronous) Clean out record.
        # POSITIONS_FLOOR:    <<39>>, # (Asynchronous) Get the last record.
        # COUNT:              <<40>>, # (Deprecated) See DATACLUSTER_COUNT.
        # POSITIONS_CEILING:  <<42>>, # Get the first record.
        # TX_COMMIT:          <<60>>, # Commit transaction.
        # DB_RELOAD:          <<73>>, # Reload database.
        # PUSH_RECORD:        <<79>>,
        # PUSH_DISTRIB_CONFIG:  <<80>>,
        # PUSH_LIVE_QUERY:    <<81>>,
        # DB_COPY:            <<90>>,
        # REPLICATION:        <<91>>,
        # CLUSTER:            <<92>>,
        # DB_TRANSFER:        <<93>>,
        # DB_FREEZE:          <<94>>,
        # DB_RELEASE:         <<95>>,
        # REQUEST_DATACLUSTER_FREEZE:   <<96>>,   # (Deprecated)
        # REQUEST_DATACLUSTER_RELEASE:  <<97>>,   # (Deprecated)
        # CREATE_SBTREE_BONSAI:         <<110>>,  # Creates an sb-tree bonsai on the remote server
        # SBTREE_BONSAI_GET:            <<111>>,  # Get value by key from sb-tree bonsai
        # SBTREE_BONSAI_FIRST_KEY:  <<112>>,      # Get first key from sb-tree bonsai
        # SBTREE_BONSAI_GET_ENTRIES_MAJOR:  <<113>>,  # Gets the portion of entries greater than the specified one. If returns 0 entries than the specified entrie is the largest.
        # RIDBAG_GET_SIZE:    <<114>>,    # Rid-bag specific operation. Send but does not save changes of rid bag. Retrieves computed size of rid bag.
        # INDEX_GET:          <<120>>,    # Lookup in an index by key
        # INDEX_PUT:          <<121>>,    # Create or update an entry in an index.
        # INDEX_REMOVE:       <<122>>,    # Remove an entry in an index by key.
        # INCREMENTAL_RESTORE:  <<123>>   # Incremental restore.

end
