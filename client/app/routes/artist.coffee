ArtistRoute = Em.Route.extend
  model: ->
    @store.findQuery 'artist', starred: true

`export default ArtistRoute`
