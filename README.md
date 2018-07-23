# Dependencies

- postgresql >= 10
- ruby 2.5.1

# Setup

First, create a user (optional) and development/test/production database

    createuser -U postgres yapp
    createdb -U postgres -O yapp yapp_production
    createdb -U postgres -O yapp yapp_test
    createdb -U postgres -O yapp yapp_development

Next, adjust ENV variables to suite your environment

    cp .env.example .env
    cp .env.example .env.test.local

Next, install gems

    bundle install

Migrate database

    bundle exec rake db:up

For test run

    RACK_ENV=test bundle exec rake db:up

# API Documentation

To generate documentation run

    bundle exec rake docs:generate

You'll find documentation under `/docs/api/index.html`

# TODO

* Setup websockets for notifications
* Setup HTTP caching (Lost-Modified, Etag etc)
* Setup webapp server for production (puma ?)

# Notes

I do not use exact string match because I think has no sense. Calculating file checksum and comparing against it is much more memory efficient and quite good for preserving data integrity.
