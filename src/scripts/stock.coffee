# Description:
#   Get a stock price or chart
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stock <info|quote|price> for <ticker> - Get a stock price
#   hubot stock chart for <ticker> - Get a stock chart for the last day
#   hubot stock chart for <ticker> -(5d|2w|2mon|1y) - Get a stock chart for the last time period
#
# Author:
#   eliperkins
#   streeter

module.exports = (robot) ->
  robot.respond /stock (info|price|quote) for @?([\w .-_]+)/i, (msg) ->
    ticker = escape(msg.match[2])
    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
      .get() (err, res, body) ->
        result = JSON.parse(body.replace(/\/\/ /, ''))

        msg.send result[0].l_cur + "(#{result[0].c})"

  robot.respond /stock chart for @?([\w]+)( -(\d+\w+))?/i, (msg) ->
    ticker = escape(msg.match[1])
    time = msg.match[3] || '1d'
    msg.send "http://chart.finance.yahoo.com/z?s=#{ticker}&t=#{time}&q=l&l=on&z=l&a=v&p=s&lang=en-US&region=US#.png"
