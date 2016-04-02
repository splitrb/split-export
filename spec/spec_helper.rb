require 'rubygems'
require 'bundler/setup'
require 'split'
require 'split/export'

RSpec.configure do |config|
  config.order = 'random'
  config.before(:each) do
    Split.configuration = Split::Configuration.new
    Split.redis.flushall
  end
end
