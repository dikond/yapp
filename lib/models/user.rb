class User < Sequel::Model(:users)
  many_to_many :analyses, join_table: :users_analyses
end
