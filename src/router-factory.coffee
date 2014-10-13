class RouterFactory

  path = require 'path'
  express = require 'express'
  snakeCase = require 'snake-case'

  PRESET_ACTIONS =
    list:   { method: 'GET'  }
    create: { method: 'POST' }
    show:   { method: 'GET'    , id: true }
    update: { method: 'PUT'    , id: true }
    remove: { method: 'DELETE' , id: true }

  constructor: (config) ->
    @_router = express.Router()
    # config.controller
    @_controller = config.controller
    # config.resource
    @_resource = config.resource
    # config.only
    @_enable config.only or Object.keys(PRESET_ACTIONS)
    # config.custom
    @_custom config.custom or []

  _enable: (actions) ->
    @_presetRoutes = []
    for action in actions
      config = PRESET_ACTIONS[action]
      config.action = action
      if config.id then id = ':id' else id = ''
      config.route = path.resolve '/', @_resource, id
      @_presetRoutes.push config

  _custom: (custom) ->
    @_customRoutes = []
    for config in custom
      config = { action: config } if typeof config is 'string'
      config.method = 'GET' unless config.method
      routePath = config.path or snakeCase(config.action).replace(/_/g,'-')
      config.route = path.resolve '/', @_resource, routePath
      @_customRoutes.push config

  getRouter: () ->
    routes = [].concat(@_customRoutes).concat(@_presetRoutes)
    for config in routes
      method = config.method.toLowerCase()
      if typeof @_controller[config.action] isnt 'function'
        throw new Error "Controller has no method '#{config.action}'"
      @_router[method](config.route, @_controller[config.action])
    @_router

  @create: (config) ->
    require('./validator').validate(config)
    (new RouterFactory config).getRouter()

module.exports = RouterFactory
