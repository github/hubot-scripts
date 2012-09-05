Tests  = require('../tests')
assert = require 'assert'
helper = Tests.helper()

require('../../src/scripts/cash') helper

# start up a danger room for hubot speak
danger = Tests.danger helper, (req, res, url) ->
  res.writeHead 200
  res.end JSON.stringify(
    {responseData: {results: [
      {unescapedUrl: url.query }
    ]}}
  )

# callbacks for when hubot sends messages
tests = [
  (msg) -> assert.equal "There is no cash information available", msg
  (msg) -> assert.equal "Ok, cash on hand is $10,000", msg
  (msg) -> assert.equal "Ok, cash on hand is $5,000", msg
  (msg) -> assert.equal "Ok, our burn rate is $1,000 per month", msg
]

# run the async tests
danger.start tests, ->
  helper.receive 'hubot cash update'
  helper.receive 'hubot cash left 10000'
  helper.receive 'hubot cash on hand is 5000'
  helper.receive 'hubot cash burn rate is 1000'
