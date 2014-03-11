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
#   johnwyles

modules.exports = (robot) ->
  robot.logger.warning "stocks.coffee has been merged with stock.coffee, update hubot-scripts.json to use stock.coffee instead"
  require('./stocks.coffee')(robot)
