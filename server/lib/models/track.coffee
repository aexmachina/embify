_ = require 'lodash'
util = require '../util'

class Track
  constructor: (@data)->
  serialize: (detail = true)->
    url = @data.link || util.id2uri 'track', @data.id # spotify-web
    obj =
      id: url
      name: @data.name
      duration: @data.duration
      popularity: @data.popularity
      starred: @data.starred
    if detail
      obj.artists = []
      @data.artists.forEach (artist)->
        obj.artists.push
          id: artist.link || util.id2uri 'artist', artist.gid # spotify-web
          name: artist.name
      if @data.disc_number # spotify-web
        obj.track = @data.number
        obj.disc = @data.disc_number
      else
        obj.album = @data.album
      obj

module.exports = Track
