IndexRoute = Ember.Route.extend
  model: ->
    $.getJSON('/a/playlist')

`export default IndexRoute`
