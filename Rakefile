task :env do
  env = ENV.fetch('RACK_ENV', 'development')
  require 'dotenv'
  Dotenv.load(".env.#{env}.local", '.env')
end

task environment: :env do
  require_relative 'environment'
end

# ----------------------------------------------------------
# Console
# ----------------------------------------------------------
desc 'Open irb with preloaded environment'
task :console do
  trap('INT', 'IGNORE')
  dir, base = File.split(FileUtils::RUBY)
  cmd =
    if base.sub!(/\Aruby/, 'irb')
      File.join(dir, base)
    else
      "#{FileUtils::RUBY} -S irb"
    end

  sh "#{cmd} -r ./environment"
end

# ----------------------------------------------------------
# Migratinons & DB stuff
# ----------------------------------------------------------
namespace :db do
  migrate = lambda do |version|
    require_relative 'db'
    require 'logger'
    Sequel.extension :migration
    DB.loggers << Logger.new($stdout)
    Sequel::Migrator.apply(DB, 'migrate', version)
  end

  desc "Migrate database to latest version"
  task up: :env do
    migrate.call(nil)
  end

  desc "Migrate database all the way down"
  task down: :env do
    migrate.call(0)
  end

  desc "Migrate database all the way down and then back up"
  task bounce: :env do
    migrate.call(0)
    Sequel::Migrator.apply(DB, 'migrate')
  end
end

# ----------------------------------------------------------
# Spec related
# ----------------------------------------------------------
require 'rspec/core/rake_task'

desc 'Generate API documentation from specs'
RSpec::Core::RakeTask.new('docs:generate') do |t|
  t.pattern = 'spec/integration/**/*_spec.rb'
  t.rspec_opts = ["--format RspecApiDocumentation::ApiFormatter"]
end
