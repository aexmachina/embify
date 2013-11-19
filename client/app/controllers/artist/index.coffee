ArtistIndexController = Em.ArrayController.extend
  actions:
    loadMore: ->
      @get('content').loadMore()

`export default ArtistIndexController`
