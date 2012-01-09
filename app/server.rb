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
          puts "Client connected to Server on port #{@port}"
          @@max_id += 1
          @sockets[socket] = {"id" => @@max_id, "color" => "gray"}
        end

        socket.onmessage do |msg|
          puts "Server Received #{msg}"
          id = @sockets[socket]["id"]
          incoming = ActiveSupport::JSON.decode(msg)
          case incoming["kind"]
          when "register"
            socket.send(register_message(id).to_json)
            broadcast(id)            
          else
            if incoming["color"]
              color = incoming["color"]
              message = {"kind" => "update", "id" => id, "color" => color}
              puts "setting #{id} to #{color}"
              @sockets[socket]["color"] = color
              send_to_all(message)
            end           
          end
        end

        socket.onclose do
          id = @sockets[socket]["id"]
          delete_message(id)
          @sockets.delete(socket)
          puts "Server closed"
        end

        socket.onerror {|e| puts "error: #{e}"}
      end
      puts "Started websocket server"
    end
  end
  
  def register_message(id)
    message = {"id" => id}
    message["kind"] = "registered"
    message["world"] = world_state
    message
  end
  
  def broadcast(id)
    message = {"id" => id}
    message["kind"] = "add"
    message["color"] = "gray"
    send_to_all(message)
  end
  
  def delete_message(id)
    message = {"id" => id}
    message["kind"] = "delete"
    send_to_all(message)
  end
  
  def send_to_all(message)
    puts "sending to all: #{message}"
    @sockets.each do |destination, color|
      destination.send(message.to_json)
    end
  end
  
  def world_state
    result = {}
    @sockets.keys.collect do |socket|
      id = @sockets[socket]["id"]
      color = @sockets[socket]["color"]
      result[id] = color
    end
    ap "world_state = #{result}"
    result
  end
end

