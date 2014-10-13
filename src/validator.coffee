validateController = (config) ->
  unless config.controller
    throw new Error 'Controller must be defined'

validateResource = (config) ->
  unless config.resource
    throw new Error 'Resource must be defined'

exports.validate = (config) ->
  validateResource config
  validateController config
