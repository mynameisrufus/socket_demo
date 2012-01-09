class Demo  
  constructor: () ->
    $(document).keypress (e) =>
      char = String.fromCharCode(e.keyCode)
      console.log char
      @socket.send char
          
  connect: ->
    @socket = new WebSocket("ws://suranyami.local:8080")
    
    @socket.onopen = () ->
      @socket.send "register"
    @socket.onmessage = (mess) ->
      if mess
        console.log(mess.data)
        
        $("#last_sent").text mess.data
  

$(document).ready ->
  demo = new Demo
  game.update()
  setInterval((-> game.update()), 50)
