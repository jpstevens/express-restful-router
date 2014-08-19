(function() {
  var ROUTES, addRouteToRouter, addRoutesToRouter, express, getMethods, getPath, path, validate, validateController, validateResource;

  express = require('express');

  path = require('path');

  ROUTES = {
    list: {
      http: 'GET'
    },
    create: {
      http: 'POST'
    },
    show: {
      http: 'GET',
      id: true
    },
    update: {
      http: 'PUT',
      id: true
    },
    remove: {
      http: 'DELETE',
      id: true
    }
  };

  validateController = function(config) {
    if (!config.controller) {
      throw new Error('Controller must be defined');
    }
  };

  validateResource = function(config) {
    if (!config.resource) {
      throw new Error('Resource must be defined');
    }
  };

  validate = function(config) {
    validateResource(config);
    return validateController(config);
  };

  getMethods = function(methods) {
    return methods || Object.keys(ROUTES);
  };

  getPath = function(route, method) {
    var id;
    if (ROUTES[method].id) {
      id = ':id';
    } else {
      id = '';
    }
    return path.resolve(route, id);
  };

  addRouteToRouter = function(router, controller, resource, method) {
    var httpVerb, id, route;
    if (ROUTES[method].id) {
      id = ':id';
    } else {
      id = '';
    }
    route = path.resolve('/', resource, id);
    httpVerb = ROUTES[method].http.toLowerCase();
    return router[httpVerb](route, controller[method]);
  };

  addRoutesToRouter = function(config) {
    var controller, method, methods, resource, router, _i, _len;
    router = express.Router();
    methods = getMethods(config.only);
    resource = config.resource;
    controller = config.controller;
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      method = methods[_i];
      addRouteToRouter(router, controller, resource, method);
    }
    return router;
  };

  module.exports = function(config) {
    if (config == null) {
      config = {};
    }
    validate(config);
    return addRoutesToRouter(config);
  };

}).call(this);
