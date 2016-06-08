require 'rubygems'
require 'bundler/setup'
require 'split'
require 'split/export'
require 'fakeredis'

fakeredis = Redis.new

RSpec.configure do |config|
  config.order = 'random'
  config.before(:each) do
    Split.configuration = Split::Configuration.new
    Split.redis = fakeredis
    Split.redis.flushall
  end
end
