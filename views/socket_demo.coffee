class Demo  
  constructor: () ->
    $(document).keypress (e) =>
      char = String.fromCharCode(e.keyCode)
      console.log char
      @socket.send char
          
  connect: ->
    @socket = new WebSocket("ws://suranyami.local:7070")
    
    @socket.onopen = () ->
      @socket.send JSON.stringify {kind: "register"}
    
    @socket.onmessage = (mess) ->
      if mess
        data =  jQuery.parseJSON(mess.data)
        console.log(data)
        switch data["kind"]
          when "registered"
            $('#me').text(data["id"])
            
$(document).ready ->
  demo = new Demo
  demo.connect()
  