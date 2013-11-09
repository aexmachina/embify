_ = require 'lodash'
util = require '../util'

class Artist
  constructor: (@data)->
  serialize: (include = {})->
    obj =
      id: util.id2uri 'artist', @data.id
      name: @data.name
      popularity: @data.popularity
    if @stars
      obj.stars = @stars
    if include.topTracks
      obj.topTracks = []
      @data.top_track.forEach (track)->
        obj.topTracks.push util.id2uri 'track', track.id
    if include.disc
      obj.track = @data.number
      obj.disc = @data.disc_number

module.exports = Artist
