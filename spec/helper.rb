require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "minitest/spec"
require "minitest/autorun"
require "rack/test"
require 'timecop'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack-affiliates'

class MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    hello_world_app = lambda do |env|
      [200, {}, "Hello World"]
    end
    
    @app = Rack::Affiliates.new(hello_world_app)
  end
end

