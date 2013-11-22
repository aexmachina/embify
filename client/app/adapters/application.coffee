ApplicationAdapter = DS.RESTAdapter.extend
  pageSize: 20
  namespace: 'api'
  defaultSerializer: '_default' # use the JSONSerializer

`export default ApplicationAdapter`
