class FakeWebclient
  def initialize(host = "0.0.0.0", port = "7070", protocol = "ws")
    @host = host
    @port = port
    @protocol = protocol
  end

  def run(message, &receive_block)
    EM.run do
      # puts "message to send = #{message}"
      conn = EventMachine::WebSocketClient.connect("#{@protocol}://#{@host}:#{@port}/")
      # puts "#{@protocol}://#{@host}:#{@port}/"
      conn.callback do
        # puts "WebSocketClient sending message: '#{message}'"
        conn.send_msg message.to_json
      end

      conn.errback do |e|
        puts "WebSocketClient got error: '#{e}'"
      end

      conn.stream do |msg|
        # puts "WebSocketClient got a response: '#{msg}'"
        receive_block.call(msg)
      end

      conn.disconnect do
        # puts "WebSocketClient disconnecting"
        EM::stop_event_loop
      end
    end
  end
end

