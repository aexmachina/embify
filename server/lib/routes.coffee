q = require 'q'
_ = require 'lodash'
spotifyUri = require 'spotify-uri'

config = require './config'
Album = require './models/album'
Artist = require './models/artist'

class Api
  init: (@app)->

    client = require('./dnode/client')
    client.connect().then (remote)=>
      @adapter = remote
      @defineRoutes()

  defineRoutes: ->
    @app.get '/api/playlists', (req, res)=>
      @adapter.getPlaylists (playlists)->
        writeJSON createModels('playlist', playlists), res

    @app.get '/api/playlists/:id', (req, res)=>
      writePlaylist = (playlist)->
        if playlist?
          writeJSON createModel('playlist', playlist), res
        else
          notFound res
      if req.params.id == 'starred'
        @adapter.getStarred writePlaylist
      else
        @adapter.getPlaylists (playlists)->
          writePlaylist _.findWhere(playlists, id: +req.params.id)

    @app.get '/api/tracks/starred', (req, res)=>
      @starred 'tracks', (tracks)-> writeJSON tracks, res

    @app.get '/api/albums/starred', (req, res)=>
      @starred 'albums', (albums)-> writeJSON albums, res

    @app.get '/api/artists/starred', (req, res)=>
      @starred 'artists', (artists)-> writeJSON artists, res

    @app.get '/api/:type/:id', (req, res)=>
      @getById req.params.type, req.params.id, req, res

    # Examples:
    # ```
    # /api/artists?starred
    # /api/albums?starred
    # /api/tracks?starred
    # /api/artists?godspeed you black emperor
    # /api/artists?id=4Z8W4fKeB5YxbusRsdQVPb
    # /api/artists?id=4Z8W4fKeB5YxbusRsdQVPb,0k17h0D3J5VfsdmQ1iZtE9
    # ```
    @app.get '/api/:type', (req, res)=>
      type = req.params.type
      if req.query.starred?
        @starred type, (results)->
          delete req.query.starred
          if !_.isEmpty req.query
            results = _.filter results, req.query
          writeJSON results, res
      else if req.query.id
        @getById req.params.type, req.query.id, req, res
      else
        # @todo
        query = if typeof req.query == 'string' then req.query else req.query.query
        if query
          search = @adapter.search query, req.query.offset, req.query.limit
          type = type
          method = "get#{type.substring(0,1).toUpperCase()}#{type.substring(1)}"
          results = search[method]()
        else
          return res.writeHead 400, 'Invalid request: either ?starred, ?id or ?query must be specified'

  starred: (type, cb)->
    @adapter.getStarred (playlist)->
      tracks = playlist.tracks
      switch type
        when 'albums'
          data = _.sortBy(albumsForTracks(tracks), 'stars').reverse()
          cb data
        when 'artists'
          data = _.sortBy(artistsForTracks(tracks), 'stars').reverse()
          cb data
        when 'tracks'
          cb createModels 'track', tracks
        else
          throw "Unknown type #{type}"

  getById: (type, id, req, res)->
    type = inflect type
    ids = if id.indexOf(',') != -1 then id.split(',') else ids = [id]
    urls = []
    for id in ids
      urls.push spotifyUri.formatURI type: type, id: id
    @adapter.get urls, (data)->
      if urls.length == 1
        writeJSON createModel(type, data[0]), res
      else
        results = (createModel type, result for result in data)
        writeJSON results, res

inflect = (type)->
  type.substring 0, type.length - 1

createModel = (type, record)->
  switch type
    when 'album'
      new Album record
    when 'artist'
      new Artist record
    when 'playlist'
      new Playlist record
    when 'track'
      new Track record

createModels = (type, records)->
  (createModel type, record for record in records)

albumsForTracks = (tracks)->
  albums = {}
  for track in tracks
    if !albums[track.album.link]
      albums[track.album.link] = new Album track.album
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

writeJSON = (models, res)->
  res.header 'Content-Type', 'text/json'
  payload = if models.length then (model.serialize() for model in models) else models.serialize()
  res.end JSON.stringify payload

notFound = (res, message = "Not found")->
  res.writeHead 404
  res.end message

handleError = ->
  console.error.apply console, arguments

module.exports = new Api
