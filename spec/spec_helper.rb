require 'rubygems'
require 'spork'

Spork.prefork do
  require 'rspec'
  require 'eventmachine'
  require 'em-spec/rspec'

  require 'em-websocket'
  require 'em-websocket-client'

  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))  
  $: << File.join(APP_ROOT, "app")
  $: << File.expand_path(File.join(File.dirname(__FILE__), "support"))
end

Spork.each_run do
  
end
