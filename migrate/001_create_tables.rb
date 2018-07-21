Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id

      column :agent, String, text: false # browser name
    end

    create_table(:analyses) do
      primary_key :id

      column :url,      String, text: false, null: false
      column :status,   String, text: false, null: false # pending, safe, unsafe
      column :checksum, String, text: true
    end

    create_table(:binary_files) do
      primary_key :id
      foreign_key :analysis_id, :analyses

      column :checksum, String, text: false
      column :content,  File
      column :metadata, :jsonb, text: true
    end

    create_join_table({ user_id: :users, analysis_id: :analyses }, name: 'users_analyses')

    %i[users analyses binary_files users_analyses].each do |t_name|
      add_column t_name, :created_at, DateTime
      add_column t_name, :updated_at, DateTime

      pgt_created_at t_name, :created_at
      pgt_updated_at t_name, :updated_at
    end
  end

  down do
    %i[users_analyses binary_files analyses users].each(&method(:drop_table))
  end
end
