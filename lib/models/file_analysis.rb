require 'core/uploader'

class FileAnalysis < Sequel::Model(:file_analyses)
  include Uploader[:file]

  many_to_one :analysis
end
