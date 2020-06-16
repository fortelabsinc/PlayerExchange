var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
  res.send('ok');
});

router.get('/healthy', function(req, res, next) {
  res.send('ok');
});

module.exports = router;
