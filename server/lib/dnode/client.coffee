Q = require 'Q'
dnode = require 'dnode'
config = require '../config'

connect = ->
  deferred = Q.defer()
  console.log 'dnode client connecting'
  d = dnode.connect port = process.env.dnodePort || config.dnodePort
  d.on 'remote', (remote)->
    console.log 'dnode client connected'
    deferred.resolve remote
  # d.on 'error', (msg)->
  #   console.error "dnode client failed on port #{port}: #{msg}"
  #   deferred.reject msg
  deferred.promise

module.exports = 
  connect: connect
