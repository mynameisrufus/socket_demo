class Demo  
  constructor: ->
    if WebSocket?
      window.socket = new WebSocket("ws://192.168.1.3:7070")    
    else
      window.socket = new MozWebSocket("ws://192.168.1.3:7070")
      
    window.socket.onopen = ->
      window.socket.send(JSON.stringify({kind: "register"}))
    
    window.socket.onmessage = (mess) ->
      if mess
        data =  jQuery.parseJSON(mess.data)
        switch data["kind"]
          when "registered"
            $('#me').text(data["id"])
            
            $.each(data["world"],  (key, color) ->
              console.log(color)
              window.add_player key, color)
          when "add"
            window.add_player data["id"], data["color"]
          when "update"
            id = data["id"]
            window.set_color(id, data["color"])
          when "delete"
            $("td##{data["id"]}").remove()
      
window.add_player = (id, color) ->
  if $("##{id}").length == 0
    $('tr').append("<td id='#{id}' class='#{color}'>&nbsp;</td>")

window.set_color = (id, color) ->
  $("##{id}").removeClass("red")
  $("##{id}").removeClass("green")
  $("##{id}").addClass(color)
  

$(document).ready ->
  demo = new Demo
  $("#red").click (e) =>
    window.socket.send(JSON.stringify({kind: "update", color: "red"}))
  $("#green").click (e) =>
    window.socket.send(JSON.stringify({kind: "update", color: "green"}))
  