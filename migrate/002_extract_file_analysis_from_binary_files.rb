Sequel.migration do
  up do
    create_table :file_analyses do
      primary_key :id
      foreign_key :analysis_id, :analyses, index: true, null: false

      column :status, String, text: false, null: false
      column :checksum, String, text: false
      column :file_data, :jsonb

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    pgt_created_at :file_analyses, :created_at
    pgt_updated_at :file_analyses, :updated_at

    alter_table :binary_files do
      drop_foreign_key :analysis_id
      drop_column :checksum
    end
  end

  down do
    drop_table :file_analyses

    alter_table :binary_files do
      add_foreign_key :analysis_id, :analyses, index: true, null: false
      add_column :checksum, String, text: false
    end
  end
end
