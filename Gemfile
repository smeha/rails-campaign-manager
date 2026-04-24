source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.8"

gem "rails", "~> 8.1"
gem "pg", "~> 1.6"
gem "puma", ">= 5"
gem "sprockets-rails"
gem "jbuilder"
gem "turbo-rails"
gem "jsbundling-rails"
gem "bootsnap", require: false
gem "bcrypt"
gem "tzinfo-data", platforms: [ :windows, :jruby ]

group :development do
  gem "web-console"
  gem "listen"
end

group :development, :test do
  gem "debug", platforms: [ :mri, :windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 8.0"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
end

