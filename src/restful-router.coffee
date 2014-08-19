express = require 'express'
path = require 'path'

ROUTES =
  list: { http: 'GET' }
  create: { http: 'POST' }
  show: { http: 'GET', id: true }
  update: { http: 'PUT', id: true }
  remove: { http: 'DELETE', id: true }

validateController = (config) ->
  unless config.controller
    throw new Error 'Controller must be defined'

validateResource = (config) ->
  unless config.resource
    throw new Error 'Resource must be defined'

validate = (config) ->
  validateResource config
  validateController config

getMethods = (methods) ->
  methods or Object.keys(ROUTES)

getPath = (route, method) ->
  if ROUTES[method].id then id = ':id' else id = ''
  path.resolve route, id

addRouteToRouter = (router, controller, resource, method) ->
  if ROUTES[method].id then id = ':id' else id = ''
  route = path.resolve '/', resource, id
  httpVerb = ROUTES[method].http.toLowerCase()
  router[httpVerb](route, controller[method])

addRoutesToRouter = (config) ->
  router = express.Router()
  methods = getMethods config.only
  resource = config.resource
  controller = config.controller
  for method in methods
    addRouteToRouter router, controller, resource, method
  router

module.exports = (config={}) ->
  validate config
  addRoutesToRouter config
