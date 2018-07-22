require 'shrine'
require 'shrine/storage/sql'
require_relative 'db'

# Will not load file into memory when moving from cache to permanent store
# https://github.com/shrinerb/shrine-sql#copying
store = Shrine::Storage::Sql.new(database: DB, table: :binary_files)
Shrine.storages = { cache: store, store: store }

Shrine.plugin :sequel
Shrine.plugin :rack_file
