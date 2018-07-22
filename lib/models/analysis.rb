class Analysis < Sequel::Model(:analyses)
  many_to_many :users, join_table: :users_analyses
  one_to_many :file_analyses

  class << self
    def find_previous(checksum:, url:)
      where(checksum: checksum, url: url).first
    end
  end
end
