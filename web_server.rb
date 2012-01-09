require 'sinatra'
require 'coffee_script'

get '/' do
  puts "index"
  File.read('views/index.html')
end

get '/jquery.js' do
  puts "jquery"
  File.read('views/jquery.js')
end

get '/socket_demo.coffee' do
  puts "socket_demo"
  coffee :socket_demo
end