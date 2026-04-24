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

group :development, :test do
  gem "debug", platforms: [ :mri, :windows ], require: "debug/prelude"
end

group :development do
  gem "web-console"
  gem "listen"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tzinfo-data", platforms: [ :windows, :jruby ]
