require 'simplecov'
require File.expand_path('../support/simplecov_quality_formatter', __FILE__)
require 'rspec/autorun'

coverage_file = File.expand_path("../coverage/covered_percent", __FILE__)
File.unlink(coverage_file) if File.exists?(coverage_file)
SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter
SimpleCov.start

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each {|f| require f}
