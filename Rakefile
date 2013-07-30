# encoding: utf-8
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rack-affiliates"
  gem.homepage = "http://github.com/alexlevin/rack-affiliates"
  gem.license = "MIT"
  gem.summary = %Q{Tracks referrals came via an affiliated links.}
  gem.description = %Q{If the user clicked through from an affiliated site, this middleware will track affiliate tag, referring url and time.} 
  gem.email = "experiment17@gmail.com"
  gem.authors = ["Alex Levin"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

task :default => :spec
