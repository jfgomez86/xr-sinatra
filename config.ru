require 'open-uri'
require 'json'
require 'erb'
require 'bundler/setup'
require "sinatra/base"
require "sinatra/namespace"
require "pry"

Bundler.require(:default, (ENV['RACK_ENV'] || 'development').to_sym)
configure(:development) do
  # Loading Environment vars in development
  require 'dotenv'
  Dotenv.load
end
Cache = Redis.new
APP_ID = ENV['APP_ID']
root = File.expand_path File.dirname(__FILE__)
require File.join( root , "app.rb" )
app = Rack::Builder.app do
  run App
end
run app
