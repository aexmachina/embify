_ = require 'lodash'
util = require '../util'

class Track
  constructor: (@data)->
  serialize: (include = {})->
    obj =
      id: util.id2uri 'track', @data.id
      name: @data.name
      duration: @data.duration
      popularity: @data.popularity
    if include.artist
      obj.artists = []
      @data.artist.forEach (artist)->
        obj.artists.push util.id2uri 'artist', artist.gid
    if include.disc
      obj.track = @data.number
      obj.disc = @data.disc_number

module.exports = Track
