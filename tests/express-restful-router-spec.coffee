shared = require './shared'
RestfulRouter = require '../src/restful-router'

describe 'RestfulRouter', ->

  shared.setup 'init app'
  shared.setup 'init controller'

  describe 'when the controller is not defined', ->

    it 'throws an error', ->
      expect(-> new RestfulRouter({ resource: 'example' })).to.throw /Controller must be defined/

  describe 'when the resource is not defined', ->

    it 'throws an error', ->
      expect(-> new RestfulRouter({ controller: @controller })).to.throw /Resource must be defined/

  describe 'by default', ->

    describe 'when the route does not have an ID', ->

      routes = [
        { http: 'get', method: 'list' }
        { http: 'post', method: 'create' }
      ]

      shared.for routes, 'calling a valid route for a resource'

    describe 'when the route has an ID', ->

      routes = [
        { http: 'get', method: 'show', route: '/example/123' }
        { http: 'put', method: 'update', route: '/example/123' }
        { http: 'delete', method: 'remove', route: '/example/123' }
      ]

      shared.for routes, 'calling a valid route for a resource with an ID'

  describe 'when "only" is defined', ->

    before ->
      @only = ['create', 'list']

    describe 'when the resource is listed in the "only" array', ->

      routes = [
        { http: 'get', method: 'list' }
        { http: 'post', method: 'create' }
      ]

      shared.for routes, 'calling a valid route for a resource'

    describe 'when the resource is not listed in the "only" array', ->

      routes = [
        { http: 'get', method: 'show', route: '/example/123' }
        { http: 'put', method: 'update', route: '/example/123' }
        { http: 'delete', method: 'remove', route: '/example/123' }
      ]

      shared.for routes, 'calling an invalid route for a resource'
