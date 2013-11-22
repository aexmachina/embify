Router = Ember.Router.extend() # ensure we don't share routes between all Router instances

Router.map ->
  @resource 'country', ->
  @resource 'artist', ->
    @resource 'view', path: '/:id', ->
      @route 'albums'
      @route 'tracks'
  @resource 'album', ->
    @resource 'view', path: '/:id', ->
      @route 'tracks'
  @resource 'track', ->
    @route 'view', path: '/:id'

`export default Router`
