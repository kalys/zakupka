lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib)

require 'goszakup'

require 'bundler'
Bundler.setup(:default)

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
  Goszakup.invoke
end

scheduler.join
