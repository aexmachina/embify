ApplicationAdapter = DS.RESTAdapter.extend
  pageSize: 10
  namespace: 'api'
  defaultSerializer: '_default' # use the JSONSerializer

`export default ApplicationAdapter`
