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
  robot.respond /stock (info|price|quote)? for @?([A-Za-z0-9.-_]+)\s?(\d+\w+)?/i, (msg) ->
    ticker = escape(msg.match[2])
    time = msg.match[4] || '1d'

    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
      .get() (err, res, body) ->
        result = JSON.parse(body.replace(/\/\/ /, ''))
        msg.send "http://chart.finance.yahoo.com/z?s=#{ticker}&t=#{time}&q=l&l=on&z=l&a=v&p=s&lang=en-US&region=US#.png"
        msg.send result[0].l_cur + "(#{result[0].c})"
