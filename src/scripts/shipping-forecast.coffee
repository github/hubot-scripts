# Description
#   Say the current shipping forecast
#
#   http://en.wikipedia.org/wiki/Shipping_Forecast
#
#   Set HUBOT_SHIPPING_FORECAST_SHIP_IT to also respond to "ship it"
#
# Dependencies:
#   "xml2js": "0.4.4"
#
# Configuration:
#   HUBOT_SHIPPING_FORECAST_SHIP_IT
#
# Commands:
#   hubot shipping forecast
#
# Author:
#   bfirsh

xml2js = require 'xml2js'
util = require 'util'
parser = new xml2js.Parser()

shippingForecast = (msg) ->
  msg
    .http('http://www.cems.uwe.ac.uk/xmlwiki/Met/shippingfull.xq')
    .get() (err, res, body) ->
      return msg.send err.message if err
      resp = ''
      parser.parseString body, (err, result) ->
        return msg.send err.message if err
        forecasts = result?['ShippingForecast']?['forecast']
        return if not forecasts
        forecast = msg.random forecasts
        msg.send "#{forecast.area[0]}. #{forecast.wind[0]} #{forecast.seastate[0]} #{forecast.weather[0]} #{forecast.visibility[0]}"

module.exports = (robot) ->
  robot.respond /shipping forecast/i, shippingForecast

  if process.env.HUBOT_SHIPPING_FORECAST_SHIP_IT
    robot.hear /ship it/i, shippingForecast
