TrackIndexRoute = Em.Route.extend Em.Pager.RouteMixin,
  model: ->
    @store.findQuery 'track', starred: true

`export default TrackIndexRoute`
