_ = require 'lodash'
SpotifyWeb = require 'spotify-web'
spotifyUri = require 'spotify-uri'

config = require './config'
spotify = require '../node_modules/node-spotify/build/Debug/spotify'
Album = require './models/album'
Artist = require './models/artist'

spotifyWeb = null
nodeSpotify = null

spotify.login(
  config.spotify.username, config.spotify.password, 
  rememberMe = false, withRemembered = false
)
spotify.ready ->
  console.log "node-spotify ready"
  nodeSpotify = spotify

SpotifyWeb.login config.spotify.username, config.spotify.password, (err, spotify)->
  console.log "spotify-web ready"
  spotifyWeb = spotify

init = (app)->
  app.get '/api/playlists', (req, res)->
    playlists = nodeSpotify.getPlaylists()
    writeJSON playlists, res
  app.get '/api/playlists/:id', (req, res)->
    playlists = nodeSpotify.getPlaylists()
    if req.params.id == 'starred'
      playlist = nodeSpotify.getStarred()
    else
      playlist = _.findWhere(playlists, id: +req.params.id)
    if playlist?
      playlist.tracks = playlist.getTracks()
      writeJSON playlist, res
    else
      notFound res
  app.get '/api/tracks/starred', (req, res)->
    writeJSON starred('tracks'), res
  app.get '/api/albums/starred', (req, res)->
    writeJSON starred('albums'), res
  app.get '/api/artists/starred', (req, res)->
    writeJSON starred('artists'), res
  # Examples:
  # ```
  # /api/artists?starred
  # /api/albums?starred
  # /api/tracks?starred
  # /api/artists?godspeed you black emperor
  # /api/artists?id=4Z8W4fKeB5YxbusRsdQVPb
  # /api/artists?id=4Z8W4fKeB5YxbusRsdQVPb,0k17h0D3J5VfsdmQ1iZtE9
  # ```
  app.get '/api/:type', (req, res)->
    type = req.params.type
    console.log req.query
    if req.query.starred?
      results = starred type
      delete req.query.starred
      if !_.isEmpty req.query
        results = _.filter results, req.query
    else if req.query.id
      if req.query.id.indexOf(',') != -1
        ids = req.query.id.split(',')
      else
        ids = [req.query.id]
      urls = []
      for id in ids
        urls.push spotifyUri.formatURI type: type, id: id
      spotifyWeb.get urls, (err, data)->
        if err then return handleError err
        if urls.length == 1 then data = [data]
        results = []
        for result in data
          results.push createModel(type, result).serialize()
        writeJSON results, res
      return
    else
      query = if typeof req.query == 'string' then req.query else req.query.query
      if query
        search = new nodeSpotify.Search query, req.query.offset, req.query.limit
        type = type
        method = "get#{type.substring(0,1).toUpperCase()}#{type.substring(1)}"
        results = search[method]()
      else
        return res.writeHead 400, 'Invalid request: either ?starred, ?id or ?query must be specified'
    
    writeJSON results, res

createModel = (type, record)->
  switch type
    when 'album'
      new Album record
    when 'artist'
      new Artist record
createModels = (type, records)->
  (createModel type, record for record in records)

albumsForTracks = (tracks)->
  albums = {}
  for track in tracks
    if !albums[track.album.link]
      albums[track.album.link] = track.album
      albums[track.album.link].stars = 1
    else
      albums[track.album.link].stars++
  albums

artistsForTracks = (tracks)->
  artists = {}
  for track in tracks
    for artist in track.artists
      if !artists[artist.link]
        artists[artist.link] = new Artist artist
        artists[artist.link].stars = 1
      else
        artists[artist.link].stars++
  artists

starred = (type)->
  playlist = getStarred()
  tracks = playlist.getTracks()
  switch type
    when 'albums'
      data = _.sortBy(albumsForTracks(tracks), 'stars').reverse()
      return createModels type, data
    when 'artists'
      console.log artistsForTracks(tracks)
      data = _.sortBy(artistsForTracks(tracks), 'stars').reverse()
      return createModels type, data
    when 'tracks'
      data = playlist.getTracks()
      return createModels type, data
    else
      throw "Unknown type #{type}"

writeJSON = (data, res)->
  res.header 'Content-Type', 'text/json'
  res.end JSON.stringify data

notFound = (res, message = "Not found")->
  res.writeHead 404
  res.end message

getStarred = ->
  nodeSpotify.getStarred()

handleError = ->
  console.error.apply console, arguments

module.exports = 
  init: init
