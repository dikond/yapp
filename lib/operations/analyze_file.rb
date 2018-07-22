require 'digest'
require 'core/operation'

module Operations
  class AnalyzeFile < Operation
    def call(record:)
      is_safe = analyze(record)
      Success(record: record, status: is_safe ? 'safe' : 'unsafe')
    end

    private

    def analyze(record)
      sleep 60 if ENV['STRONK_ANALYSIS']
      record.file.metadata['size'].to_i.even?
    end
  end
end
