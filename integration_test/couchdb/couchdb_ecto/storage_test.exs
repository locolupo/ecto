defmodule Couchdb.Ecto.StorageTest do
  use ExUnit.Case

  @database_properties %{hostname: "127.0.0.1", database: "couchdb_ecto_test", port: 5984}
  @database_server_url "http://#{@database_properties[:hostname]}:#{@database_properties[:port]}"

  setup context do
    cleanup
    on_exit(context, fn -> cleanup end)
  end

  test "storage_up/1" do
    Couchdb.Ecto.Storage.storage_up @database_properties

    assert db_exists
  end

  test "storage_down/1" do
    Couchdb.Ecto.Storage.storage_up @database_properties

    Couchdb.Ecto.Storage.storage_down @database_properties

    assert !db_exists    
  end

  def cleanup do
    server = :couchbeam.server_connection(@database_server_url, [])
    :couchbeam.delete_db(server, @database_properties[:database])
  end

  def db_exists do
    server = :couchbeam.server_connection(@database_server_url, [])
    :couchbeam.db_exists(server, @database_properties[:database])
  end
end
