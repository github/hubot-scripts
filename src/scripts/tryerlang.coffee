# erl <expr> - Evaluate an Erlang Expression on tryerlang.org and return the result
#
# By Roberto Aloi (@robertoaloi)

QS = require "querystring"

module.exports = (robot) ->
  robot.respond /(tryerlang|erl) (.*)/i, (msg) ->
    expr = msg.match[2]
    data = QS.stringify({'expression': expr})
    msg.http('http://www.tryerlang.org/api/eval/default/intro')
      .post(data) (err, res, body) ->
        response = JSON.parse(body)
        msg.send response.result
