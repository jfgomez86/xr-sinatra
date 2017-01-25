$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
  test.warning = false
end
task default: :test
