ApplicationSerializer = DS.JSONSerializer.extend
  extractArray: (store, type, payload)->
    @_super store, type, payload.data

`export default ApplicationSerializer`
