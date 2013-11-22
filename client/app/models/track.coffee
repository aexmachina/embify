Track = DS.Model.extend
  name: DS.attr 'string'
  stars: DS.attr 'number'

  # albums: DS.hasMany 'album'
  # tracks: DS.hasMany 'tracks'

`export default Track`
