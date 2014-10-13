# express-restful-router

## Usage

First off, install the package:
```bash
npm install express-restful-router --save
```

Then, require it in your project:
```javascript
var RestfulRouter = require('express-restful-router');
```

You can then pass a configuration option into the `RestfulRouter` to return a new router:
```javascript
var router = RestfulRouter({
  /* options goes here */
});
```

## Options

### resource

**Required:**
yes

**Type:**
`String`

**Description:**
Sets the name of the resource for the restful router.
The end-point is generated based on the name of the resource.

**Example:**
```javascript
router = RestfulRouter({
  resource: 'example', // translates to "/example" endpoint
  // more config...
});
```

By default, the following end-points are created:

- `GET /example` (maps to the `list` controller method)
- `POST /example` (maps to the `create` controller method)
- `GET /example/:id` (maps to the `show` controller method)
- `PUT /example/:id` (maps to the `update` controller method)
- `DELETE /example/:id` (maps to the `remove` controller method)


### controller

**Required:**
yes

**Type:**
`Object`

**Description:**
Defines the controller that your restful router maps to.
By default, the methods it expects are: `list`, `create`, `show`, `update`, `remove`.

For single-resource methods (such as `show`, `update` and `remove`) the resource ID is available as `req.params.id`.

**Example:**
```javascript
router = RestfulRouter({
  controller: {
    show: function (req, res) {
      res.send('Showing #' + req.params.id);
    }
    // more controller methods...
  }
  // more config...
});
```

### only

**Required:**
no

**Type:**
`[String]`

**Description:**
Define which pre-set routes are enabled.

**Example:**
```javascript
router = RestfulRouter({
  resource: 'example',
  only: [
    'show', // GET /example/:id
    'list' // GET /example
  ],
  controller: {
    show: function (req, res) {
      res.send('Showing example #' + req.params.id);
    },
    list: function (req, res) {
      res.send('Listing examples');
    }
  }
});
```

### custom

**Required:**
no

**Type:**
`[String|Object]`

**Description:**
Custom route configuration. May be a string (which creates a default getter with a method of the same name), or an object (where you can define `action`, `path` and `method`).

**Example:**
```javascript
router = RestfulRouter({
  resource: 'example',
  only: [],
  custom: [
    'yes', // GET /example/yes
    { action: 'noThanks' }, // GET /example/no-thanks
    { action: 'maybe', path: './maybe', method: 'GET' } // GET /example/maybe
  ],
  controller: {
    yes: function (req, res) {},
    noWay: function (req, res) {},
    maybe: function (req, res) {}
  }
});
```
