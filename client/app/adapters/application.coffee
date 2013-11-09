ApplicationAdapter = DS.RESTAdapter.extend
  pageSize: 50
  namespace: 'api'
  defaultSerializer: '_default' # use the JSONSerializer

`export default ApplicationAdapter`
