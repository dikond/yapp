class Analysis < Sequel::Model(:analyses)
  many_to_many :users, join_table: :users_analyses
  one_to_many :binary_files
end
