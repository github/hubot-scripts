Tests  = require('../tests')
assert = require 'assert'
helper = Tests.helper()

require('../../src/scripts/isup') helper

# start up a danger room for hubot
danger = Tests.danger helper, (req, res, url) ->
  if url.pathname == "/fivehundrederror.com"
    res.writeHead 500
    res.end "Zomg!"
  else
    res.writeHead 200
    if url.pathname == "/alwaysup.com"
      res.end "It's just you."
    else
      res.end "It's not just you!"

# callbacks for when hubot sends messages
tests = [
  (msg) -> assert.equal "alwaysup.com looks UP from here.", msg,
  (msg) -> assert.equal "alwaysdown.com looks DOWN from here.", msg
  (msg) -> assert.equal "Not sure, fivehundrederror.com returned an error.", msg
]

# run the async tests
danger.start tests, ->
  helper.receive 'helper: is alwaysup.com up'
  helper.receive 'helper: is alwaysdown.com down'
  helper.receive 'helper: is fivehundrederror.com up?'

