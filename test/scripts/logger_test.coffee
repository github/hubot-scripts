Tests  = require '../tests'
assert = require 'assert'
helper = Tests.helper()

require('../../src/scripts/logger') helper

danger = Tests.danger helper, (req, res, url) ->
  res.responseCode = 200
  res.setHeader 'Content-Length', 0
  res.end

tests = [
  (msg) -> (assert (("Logging is already enabled." == msg) ||
                    (msg.indexOf("I will log") != -1))),
  (msg) -> (assert msg.indexOf("OK, I'll stop") != 1),
]

danger.start test, ->
  helper.receive "helper start logging"
  helper.recieve "helper stop logging"
