require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'active_support'
require 'json'
require 'ap'

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../app")

class Server
  def initialize(host = '0.0.0.0', port = 7070)
    @host = host
    @port = port
    @@max_id = 0
  end

  def run
    EM.run do
      @sockets = {}
      EM::WebSocket.start(:host => @host, :port => @port) do |socket|
        socket.onopen do
          puts "Client connected to Server"
          @@max_id += 1
          @sockets[socket] = {"id" => @@max_id}
        end

        socket.onmessage do |msg|
          puts "Server Received #{msg}"
          sender_id = @sockets[socket]["id"]
          incoming = ActiveSupport::JSON.decode(msg)
          case incoming["kind"]
          when "register"
            message = {"id" => sender_id}
            message["kind"] = "registered"
            puts message
            socket.send(message.to_json)
          else
            if incoming["value"]
              message = {"kind" => "update", "sender_id" => sender_id, "value" => incoming["value"]}
              puts message
              socket.send(message.to_json) 
            end           
          end
        end

        socket.onclose do
          @sockets.delete(socket)
          puts "Server closed"
        end

        socket.onerror {|e| puts "error: #{e}"}
      end
      puts "Started websocket server"
    end
  end
end

