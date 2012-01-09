#!/usr/bin/env ruby
require 'rubygems'
require 'ap'

path = File.expand_path(File.join(File.dirname(__FILE__), '../app'))
$LOAD_PATH << path
require 'server'
Server.new.run
