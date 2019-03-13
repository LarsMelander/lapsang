defmodule Request do
  defmacro request do
    %{
      # Server (CONNECT Operations)
      SHUTDOWN:     <<1>>,  # Shut down server.
      CONNECT:      <<2>>,  # Required initial operation to access to server commands.
      DB_OPEN:      <<3>>,  # Required initial operation to access to the database.
      DB_CREATE:    <<4>>,  # Add a new database.
      DB_EXIST:     <<6>>,  # Check if database exists.
      DB_DROP:      <<7>>,  # Delete database.
      CONFIG_GET:   <<70>>, # Get a configuration property.
      CONFIG_SET:   <<71>>, # Set a configuration property.
      CONFIG_LIST:  <<72>>, # Get a list of configuration properties.
      DB_LIST:      <<74>>, # Get a list of databases.

      # Database (DB_OPEN Operations)
      DB_CLOSE:           <<5>>,  # Close a database.
      DB_SIZE:            <<8>>,  # Get the size of a database (in bytes).
      DB_COUNTRECORDS:    <<9>>,  # Get total number of records in a database.
      DATACLUSTER_ADD:    <<10>>, # (Deprecated) Add a data cluster.
      DATACLUSTER_DROP:   <<11>>, # (Deprecated) Delete a data cluster.
      DATACLUSTER_COUNT:  <<12>>, # (Deprecated) Get the total number of data clusters.
      DATACLUSTER_DATARANGE:  <<13>>, # (Deprecated) Get the data range of data clusters.
      DATACLUSTER_COPY:       <<14>>, # Copy a data cluster.
      DATACLUSTER_LH_CLUSTER_IS_USED: <<16>>,
      RECORD_METADATA:    <<29>>, # Get metadata from a record.
      RECORD_LOAD:        <<30>>, # Load a record.
      RECORD_LOAD_IF_VERSION_NOT_LATEST:  <<44>>, # Load a record.
      RECORD_CREATE:      <<31>>, # Add a record. (Asynchronous)
      RECORD_UPDATE:      <<32>>, # (Asynchronous)
      RECORD_DELETE:      <<33>>, # (Asynchronous) Delete a record.
      RECORD_COPY:        <<34>>, # (Asynchronous) Copy a record.
      RECORD_CLEAN_OUT:   <<38>>, # (Asynchronous) Clean out record.
      POSITIONS_FLOOR:    <<39>>, # (Asynchronous) Get the last record.
      COUNT:              <<40>>, # (Deprecated) See DATACLUSTER_COUNT.
      COMMAND:            <<41>>, # Execute a command.
      POSITIONS_CEILING:  <<42>>, # Get the first record.
      TX_COMMIT:          <<60>>, # Commit transaction.
      DB_RELOAD:          <<73>>, # Reload database.
      PUSH_RECORD:        <<79>>,
      PUSH_DISTRIB_CONFIG:  <<80>>,
      PUSH_LIVE_QUERY:    <<81>>,
      DB_COPY:            <<90>>,
      REPLICATION:        <<91>>,
      CLUSTER:            <<92>>,
      DB_TRANSFER:        <<93>>,
      DB_FREEZE:          <<94>>,
      DB_RELEASE:         <<95>>,
      REQUEST_DATACLUSTER_FREEZE:   <<96>>,   # (Deprecated)
      REQUEST_DATACLUSTER_RELEASE:  <<97>>,   # (Deprecated)
      CREATE_SBTREE_BONSAI:         <<110>>,  # Creates an sb-tree bonsai on the remote server
      SBTREE_BONSAI_GET:            <<111>>,  # Get value by key from sb-tree bonsai
      SBTREE_BONSAI_FIRST_KEY:  <<112>>,      # Get first key from sb-tree bonsai
      SBTREE_BONSAI_GET_ENTRIES_MAJOR:  <<113>>,  # Gets the portion of entries greater than the specified one. If returns 0 entries than the specified entrie is the largest.
      RIDBAG_GET_SIZE:    <<114>>,    # Rid-bag specific operation. Send but does not save changes of rid bag. Retrieves computed size of rid bag.
      INDEX_GET:          <<120>>,    # Lookup in an index by key
      INDEX_PUT:          <<121>>,    # Create or update an entry in an index.
      INDEX_REMOVE:       <<122>>,    # Remove an entry in an index by key.
      INCREMENTAL_RESTORE:  <<123>>   # Incremental restore.
    }
  end

  defmacro __using__(_opts) do
    quote do
      require Request
    end
  end
end
