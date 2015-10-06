osc = require "osc"
WebSocketServer = require('ws').Server

# Configuration

config = {
  webSocketPort: 8080
  udpPort: 3333
}


# Set up web socket server

wss = new WebSocketServer({port: 8080})
console.log "Created web socket server on port #{config.webSocketPort}"

wss.on "connection", ->
  console.log "Client connected to web socket"

broadcast = (data) ->
  wss.clients.forEach (client) ->
    client.send(data)


# Set up OSC listener over UDP

udpPort = new osc.UDPPort {
  localAddress: "0.0.0.0"
  localPort: config.udpPort
}

udpPort.on "ready", ->
  console.log "Listening for OSC over UDP port #{config.udpPort}"

udpPort.on "message", (oscMessage) ->
  broadcast(JSON.stringify(oscMessage))
  console.log oscMessage

udpPort.open()
