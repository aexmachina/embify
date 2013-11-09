IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo 'artist'

`export default IndexRoute`
