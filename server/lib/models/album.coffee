_ = require 'lodash'
Track = require './track'
util = require '../util'

class Album
  constructor: (@data)->
  serialize: (include = artist: true)->
    obj = 
      id: util.id2uri 'album', @data.gid
      name: @data.name
      covers: {}
      discs: {}
    @data.cover.forEach (image)->
      uri = image.uri
      obj.covers[image.size] = uri
    @data.disc.forEach (disc)->
      tracks = []
      disc.track.forEach (track)->
        tracks.push util.id2uri 'track', track.gid
      obj.discs[disc.number] = tracks
    if include.artist
      obj.artists = []
      @data.artist.forEach (artist)->
        obj.artists.push id: util.id2uri('artist', artist.gid), name: artist.name
    if include.full
      _.extend obj, 
        label: @data.label
        date: @data.date
        popularity: @data.popularity
        review: @data.review
        genres: []
      @data.genre.forEach (genre)->
        @data.genres.push genre
    obj

module.exports = Album
