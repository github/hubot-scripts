# Description:
#   Finance charts
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stock me <ticker> - show today's stock chart for <ticker>
#   hubot stock me -(5d|2w|2mon|1y) <ticker> - show stock chart for <ticker>
#
# Author:
#   maddox

module.exports = (robot) ->

  robot.respond /stock( me)?( -(\d+\w+))? (.*)/i, (msg) ->
    ticker = msg.match[4]
    time = msg.match[3] || '1d'
    msg.send "http://chart.finance.yahoo.com/z?s=#{ticker}&t=#{time}&q=l&l=on&z=l&a=v&p=s&lang=en-US&region=US#.png"
