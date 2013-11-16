dnode = require 'dnode'
util = require 'util'
config = require './lib/config'
SpotifyAdapter = require('./lib/spotify-adapter').SpotifyAdapter

class Api extends SpotifyAdapter
  getStarred: ->
    playlist = super
    playlist.tracks = playlist.getTracks()
    playlist

adapter = new Api()
adapter.connect config.spotify.username, config.spotify.password
adapter.on 'load', ->
  console.log 'dnode-server loaded api'

api = require('dnode-object').wrap adapter,
  include: ['getPlaylists', 'getStarred', 'search', 'get']
  exclude: ['connect']
server = dnode api

server.listen port = process.env.port || config.dnodePort
console.log "dnode-server listening on port #{port}"
