# Description:
#   None
#
# Dependencies:
#   "querystring": "0.1.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot erl <expr> - Evaluate an Erlang Expression on tryerlang.org and return the result
#
# Author:
#   Roberto Aloi (@robertoaloi)

QS = require "querystring"

module.exports = (robot) ->
  robot.respond /(tryerlang|erl) (.*)/i, (msg) ->
    expr = msg.match[2]
    data = QS.stringify({'expression': expr})
    msg.http('http://www.tryerlang.org/api/eval/default/intro')
      .post(data) (err, res, body) ->
        response = JSON.parse(body)
        msg.send response.result
