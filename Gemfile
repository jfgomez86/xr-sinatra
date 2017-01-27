source 'https://rubygems.org'

ruby '2.3.1'

gem 'rmagick', '2.16.0'
#sinatra
gem 'sinatra'
github 'sinatra/sinatra' do
  gem 'sinatra-contrib'
end

#active model
gem 'activemodel'
gem 'activerecord'
gem 'activesupport'
gem 'virtus'

gem 'redis', '3.3.2'
gem 'foreman', '0.82.0'
# tasks
gem "rake"

group :development do
  gem 'dotenv', '~> 2.1', '>= 2.1.1'
end

group :development, :test do
  gem "rack-test"
  gem "pry"
end

group :test do
  gem 'minitest'
  gem 'minitest-matchers'
  gem 'valid_attribute'
  gem 'minitest-reporters'
end
