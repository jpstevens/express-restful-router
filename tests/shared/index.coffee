shared = require 'mocha-shared'
RestfulRouter = require '../../src'

shared.setup 'init app router', (resource) ->

  beforeEach ->
    @config or= {}
    @config.resource = resource
    @config.controller = @controller
    @config.only = @only
    @config.custom = @custom
    @app.use '/', RestfulRouter @config

shared.setup 'init controller', ->

  beforeEach ->
    @controller = require '../mocks/mock-controller'

shared.setup 'init app', ->

  beforeEach ->
    @app = express()

shared.setup 'make request', ->

  beforeEach (done) ->
    request(@app)[@method](@route).end (err, res) =>
      @res = res
      done()

shared.behavior 'it calls the expected controller method', ->

  shared.setup 'init app router', 'example'
  shared.setup 'make request'

  it 'calls the expected controller method', ->

    expect(@res.body.message).to.equal @action

shared.behavior 'it assigns the expected ID', ->

  shared.setup 'init app router', 'example'
  shared.setup 'make request'

  it 'assigns the expected ID', ->

    expect(@res.body.id).to.equal @id

shared.scenario 'calling a valid route for a resource', (config) ->

  describe "to #{config.action} a resource", ->

    beforeEach ->
      @method = config.method
      @route = config.route or '/example'
      @action = config.action

    shared.behavior 'it calls the expected controller method'

shared.scenario 'calling a valid route for a resource with an ID', (config) ->

  describe "to #{config.action} a resource", ->

    beforeEach ->
      @method = config.method
      @route = config.route or '/example'
      @action = config.action
      @id = '123'

    shared.behavior 'it calls the expected controller method'
    shared.behavior 'it assigns the expected ID'

shared.scenario 'calling an invalid route for a resource', (config) ->

  describe "to #{config.action} a resource", ->

    beforeEach ->
      @method = config.method
      @route = config.route or '/example'
      @action = config.action

    shared.setup 'init app router', 'example'
    shared.setup 'make request'

    it 'returns a 404 status', ->
      expect(@res.status).to.equal 404

module.exports = shared
