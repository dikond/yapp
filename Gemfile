# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.5.1'

# core
gem 'rack'
gem 'rake'
gem 'roda'
gem 'sequel'
gem 'sequel_pg'
gem 'interactor'
gem 'jwt'

gem 'batteries', require: false

group :development do
  gem 'rerun'
  gem 'thin'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development, :test do
  gem 'dotenv'
  gem 'pry-byebug'
  gem 'rspec_api_documentation'
end
