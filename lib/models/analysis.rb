class Analysis < Sequel::Model(:analyses)
  many_to_many :users, join_table: :users_analyses
  one_to_many :file_analyses

  class << self
    def find_previous(url:, checksum:)
      where(url: url, checksum: checksum).first
    end
  end
end
