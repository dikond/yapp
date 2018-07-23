require 'core/operation'
require 'concurrent-edge'
require 'digest'

module Operations
  class Analyze < Operation
    params_validation do
      required(:user).filled
      required(:url).filled(:str?)
      required(:files).each do
        schema do
          required(:filename).filled(:str?)
          required(:type).filled(:str?)
          required(:name).filled(:str?)
          required(:tempfile).filled
        end
      end
    end

    def call(params)
      output         = yield validate(params)
      prepared_files = yield prepare_files(output)
      checksum       = yield calc_checksum(prepared_files)

      prev_analysis  = find_analysis(output, checksum)
      unless prev_analysis.nil?
        update_history(output[:user], prev_analysis)
        return Success(prev_analysis)
      end

      analysis = yield create_analysis(output, checksum)
      files    = yield create_files(analysis, prepared_files)
      results  = yield analyze_files(files)

      update_status(analysis, results)
      update_history(output[:user], analysis)
      Success(analysis)
    end

    private

    def prepare_files(output)
      files = output[:files].map do |params|
        { file: params, status: 'pending', checksum: calc_file_checksum(params[:tempfile]) }
      end

      Success(files)
    end

    def calc_file_checksum(file)
      md5 = Digest::MD5.new

      while buffer = file.read(4096)
        md5 << buffer
      end

      file.rewind
      md5.hexdigest
    end

    def calc_checksum(files)
      file_checksums = files.map { |fp| fp[:checksum] }.sort.join
      Success(Digest::MD5.hexdigest(file_checksums))
    end

    def find_analysis(output, checksum)
      Analysis.find_previous(checksum: checksum, url: output[:url])
    end

    def update_history(user, analysis)
      user.add_analysis(analysis)
    end

    def create_analysis(output, checksum)
      record = Analysis.create(status: 'pending', url: output[:url], checksum: checksum)
      Success(record)
    end

    def create_files(analysis, prepared_files)
      files = prepared_files.map { |params| analysis.add_file_analysis(params) }
      Success(files)
    end

    # Parallel background processing
    # https://github.com/ruby-concurrency/concurrent-ruby/blob/3265766bce62ceb5a9852fcf50463e1a837f4448/doc/promises.in.md#parallel-background-processing
    def analyze_files(files)
      jobs = files.map do |f|
        Concurrent::Promises.future(f) { Operations::AnalyzeFile.new.call(record: f) }
      end

      results = Concurrent::Promises.zip(*jobs).value!
      Success(results)
    end

    def update_status(analysis, results)
      all_stats = Set.new

      results.each do |result|
        record, status = result.value!.values_at(:record, :status)
        all_stats << status
        record.update(status: status)
      end

      all_safe = all_stats.to_a == %w[safe]
      analysis.update(status: all_safe ? 'safe' : 'unsafe')
    end
  end
end
