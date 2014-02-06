# Description:
#   Get a stock price
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stock <info|quote|price> for <ticker> - Get a stock price
#
# Author:
#   eliperkins

module.exports = (robot) ->
  robot.respond /stock (info|price|quote) for @?([\w .-_]+)/i, (msg) ->
    ticker = escape(msg.match[2])
    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
      .get() (err, res, body) ->
        if err or !body
          msg.send 'There was an error looking up stock information.'
        else
          result = JSON.parse(body.replace(/\/\/ /, ''))

          msg.send result[0].l_cur + "(#{result[0].c})"
