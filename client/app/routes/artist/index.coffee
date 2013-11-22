`import PaginationRouteMixin from 'appkit/utils/pagination'`

ArtistIndexRoute = Em.Route.extend PaginationRouteMixin,
  model: ->
    @store.findQuery 'artist', starred: true

`export default ArtistIndexRoute`
