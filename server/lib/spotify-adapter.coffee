Q = require 'q'
SpotifyWeb = require 'spotify-web'
spotifyUri = require 'spotify-uri'
EventEmitter = require('events').EventEmitter
_ = require 'lodash'

nodeSpotify = require('../node_modules/node-spotify/build/Release/spotify')
  appkeyFile: require('path').resolve __dirname, '../../spotify_appkey.key'

class SpotifyAdapter extends EventEmitter

  connect: (username, password)->
    console.log "connecting to spotify services..."
    nodeSpotifyLoaded = Q.defer()
    nodeSpotify.login username, password, rememberMe = false, withRemembered = false
    nodeSpotify.ready =>
      console.log "node-spotify ready"
      @nodeSpotify = nodeSpotify
      nodeSpotifyLoaded.resolve()
    # nodeSpotifyLoaded.resolve() # debug
    
    spotifyWebLoaded = Q.defer()
    # SpotifyWeb.login username, password, (err, spotifyWeb)=>
    #   console.log "spotify-web ready"
    #   @spotifyWeb = spotifyWeb
    #   spotifyWebLoaded.resolve()
    spotifyWebLoaded.resolve() # debug

    p = Q.all([nodeSpotifyLoaded.promise, spotifyWebLoaded.promise]).then =>
      console.log "spotify services connected"
      @emit 'load'
    p

  getPlaylists: ->
    @nodeSpotify.getPlaylists()

  getStarred: ->
    @nodeSpotify.getStarred()

  search: (query, offset, limit)->
    new nodeSpotify.Search query, offset, limit

  get: (urls, cb)->
    @_getNodeSpotify urls, cb

  _getNodeSpotify: (urls, cb)->
    urls = ("" + url for url in urls)
    rv = (@nodeSpotify.createFromLink url for url in urls)
  _getSpotifyWeb: (urls, cb)->
    urls = ("" + url for url in urls)
    @spotifyWeb.get urls, cb

module.exports = SpotifyAdapter: SpotifyAdapter
