ENV['RACK_ENV'] = 'test'
ROOT_PATH = File.dirname(__dir__)
$LOAD_PATH.unshift(ROOT_PATH)

require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'valid_attribute'
require 'minitest/matchers'
