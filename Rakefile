# ----------------------------------------------------------
# Migratinons & DB stuff
# ----------------------------------------------------------
require 'batteries'
Batteries::Tasks.new

# ----------------------------------------------------------
# Spec related
# ----------------------------------------------------------
require 'rspec/core/rake_task'

desc 'Generate API documentation from specs'
RSpec::Core::RakeTask.new('docs:generate') do |t|
  t.pattern = 'spec/integration/**/*_spec.rb'
  t.rspec_opts = ["--format RspecApiDocumentation::ApiFormatter"]
end
