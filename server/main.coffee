config = require './lib/config'
app = require './lib/app'
express = require 'express'

app.use express.static './dist'
app.listen process.env.PORT || config.httpPort, ->
  console.log "Listening on port #{config.httpPort}"
