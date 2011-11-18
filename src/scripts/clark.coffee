# clark - build sparklines out of data

clark = require('clark').clark

module.exports = (robot) ->
  robot.respond /clark (.*)/i, (msg) ->
    data = msg.match[1].trim().split(' ')
    msg.send(clark.sparks(data))

