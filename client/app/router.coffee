Router = Ember.Router.extend() # ensure we don't share routes between all Router instances

Router.map ->
  @resource 'artist', ->
    @resource 'view', path: '/:id', ->
      @route 'albums'
      @route 'tracks'
  @resource 'album', ->
    @resource 'view', path: '/:id', ->
      @route 'tracks'
  @route 'track', path: '/track/:id'

`export default Router`
