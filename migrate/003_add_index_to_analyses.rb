Sequel.migration do
  up do
    add_index :analyses, %i[url checksum], unique: true
  end

  down do
    drop_index :analyses, %i[url checksum]
  end
end
