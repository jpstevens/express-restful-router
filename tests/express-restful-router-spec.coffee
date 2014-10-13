shared = require './shared'
RestfulRouter = require '../src'

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
        { method: 'get', action: 'list' }
        { method: 'post', action: 'create' }
      ]

      shared.for routes, 'calling a valid route for a resource'

    describe 'when the route has an ID', ->

      routes = [
        { method: 'get', action: 'show', route: '/example/123' }
        { method: 'put', action: 'update', route: '/example/123' }
        { method: 'delete', action: 'remove', route: '/example/123' }
      ]

      shared.for routes, 'calling a valid route for a resource with an ID'

  describe 'when "only" is defined', ->

    before ->
      @only = ['create', 'list']

    describe 'when the resource is listed in the "only" array', ->

      routes = [
        { method: 'get', action: 'list' }
        { method: 'post', action: 'create' }
      ]

      shared.for routes, 'calling a valid route for a resource'

    describe 'when the resource is not listed in the "only" array', ->

      routes = [
        { method: 'get', action: 'show', route: '/example/123' }
        { method: 'put', action: 'update', route: '/example/123' }
        { method: 'delete', action: 'remove', route: '/example/123' }
      ]

      shared.for routes, 'calling an invalid route for a resource'

  describe 'when "custom" is defined', ->

    describe 'and config is a string (i.e. action)', ->

      before ->
        @custom = ['getMetaData']

      shared.scenario 'calling a valid route for a resource',
        { method: 'get', action: 'getMetaData', route: '/example/get-meta-data' }

    describe 'and config is an object', ->

      describe 'with action defined', ->

        before ->
          @custom = [{ action: 'find' }]

        shared.scenario 'calling a valid route for a resource',
          { method: 'get', action: 'find', route: '/example/find' }

      describe 'with action and method defined', ->

        before ->
          @custom = [{ action: 'stopSomething', method: 'POST' }]

        shared.scenario 'calling a valid route for a resource',
          { method: 'post', action: 'stopSomething', route: '/example/stop-something' }

      describe 'with action, method and path defined', ->

        before ->
          @custom = [{ action: 'start', method: 'POST', path: './go-to-start' }]

        shared.scenario 'calling a valid route for a resource',
          { method: 'post', action: 'start', route: '/example/go-to-start' }
