# sandbox - run javascript in a sandbox!. Usage: /run <javascript> or /sandbox <javascript> 

Sandbox = require('Sandbox')

module.exports = (robot) ->
  robot.respond /(run|sandbox) (.*)/i, (msg) ->
    sandbox = new Sandbox
    sandbox.run(msg.match[2], (output) ->
      msg.send output.result
    )
