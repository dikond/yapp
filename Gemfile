# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.5.1'

gem 'rack'
gem 'rake'
gem 'roda'
gem 'jwt'
gem 'sequel'
gem 'sequel_pg'
gem 'sequel_postgresql_triggers'
gem 'dry-monads'
gem 'dry-validation'
gem 'concurrent-ruby-edge'
gem 'shrine'
gem 'shrine-sql'

group :development do
  gem 'rerun'
  gem 'thin'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'dotenv'
  gem 'pry-byebug'
  gem 'rspec_api_documentation'
end
