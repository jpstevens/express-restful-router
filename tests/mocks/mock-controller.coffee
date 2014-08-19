module.exports =
  list: (req, res) -> res.json { message: "list" }
  create: (req, res) -> res.json { message: "create" }
  show: (req, res) -> res.json { message: "show", id: req.params.id }
  update: (req, res) -> res.json { message: "update", id: req.params.id }
  remove: (req, res) -> res.json { message: "remove", id: req.params.id }
