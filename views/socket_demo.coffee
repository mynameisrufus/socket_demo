class Demo  
  constructor: () ->
    $(document).keypress (e) =>
      char = String.fromCharCode(e.keyCode)
      message = JSON.stringify({kind: "update", value: char})
      console.log message
      window.socket.send message
  
  connect: ->
    window.socket = new WebSocket("ws://0.0.0.0:7070")
    
    window.socket.onopen = ->
      window.socket.send(JSON.stringify({kind: "register"}))
    
    window.socket.onmessage = (mess) ->
      if mess
        data =  jQuery.parseJSON(mess.data)
        console.log(data)
        switch data["kind"]
          when "registered"
            $('#me').text(data["id"])
            $.each(data["world"],  (key, value) -> window.add_player key, value)
          when "add"
            window.add_player data["id"], data["value"]
          when "update"
            id = data["id"]
            value = data["value"]
            $("#value_#{id}").text(value)
            window.set_color(id, data["color"])
          when "delete"
            $("##{data["id"]}").remove()
      
window.add_player = (id, value) ->
  if $("##{id}").length == 0
    console.log("id: #{id}  value: #{value}")
    $('#display').append("<div class='player' id='#{id}'>#{id}: <span id='value_#{id}'>#{value || ''}</span></div>")

window.set_color = (id, color) ->
  $("##{id}").removeClass("red")
  $("##{id}").removeClass("green")
  $("##{id}").addClass(color)
  

$(document).ready ->
  demo = new Demo
  demo.connect()
  $("#red").click (e) =>
    window.socket.send(JSON.stringify({kind: "update", value: " ", color: "red"}))
  $("#green").click (e) =>
    window.socket.send(JSON.stringify({kind: "update", value: " ", color: "green"}))
  