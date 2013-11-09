# It all starts with the route

This is Ember, after all...

    FooRoute = Em.Route.extend
      willPaginate: true
      model: ->
        # this should inject `offset` and `limit` into the request
        @store.findAll 'foo'

The `ArrayProxy` should now have the following properties:

   - `total`
   - `page`
   - `numPages`

# In progress...

    PagingSerializerMixin = Em.Mixin.create
      extractArray: (store, type, payload)->

    DS.Resolver = Em.Object.extend
      promise: null
      meta: null

store.push
store.pushMany
recordArray.load

# Unaddressed

- store.findHasMany()

# References

1. http://discuss.emberjs.com/t/pagination-with-ember-data-can-we-agree-on-a-single-solution/742
2. 
