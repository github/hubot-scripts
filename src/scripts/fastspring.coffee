# Description
#   An HTTP listener for FastSpring payment notifications
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FASTSPRING_PRIVATE_KEY
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/fastspring
#     room=<room>
#     fullName=<customer's full name>
#     email=<customer's email>
#     productName=<product name, can also be an array of products>
#     totalPriceValue=<total price value>
#     totalPriceCurrency=<total price currency>
#     url=<invoice's url>
#
# Notes:
#   See FastSpring notifications overview for further details
#   https://support.fastspring.com/entries/236490-Notifications-Overview
#
# Author:
#   matteoagosti

http = require "http"
querystring = require "querystring"
crypto = require "crypto"

module.exports = (robot) ->
  privateKey = process.env.HUBOT_FASTSPRING_PRIVATE_KEY

  unless privateKey
    robot.logger.error "Please set the HUBOT_FASTSPRING_PRIVATE_KEY environment variable."
    return

  robot.router.post "/hubot/fastspring", (req, res) ->
    query = req.body
    res.end

    unless query.room
      return

    unless crypto.createHash("md5").update(query.security_data + privateKey, 'utf8').digest('hex') is query.security_hash
      return

    robot.messageRoom query.room, "#{query.fullName} (#{query.email}) just bought #{query.productName} for #{query.totalPriceValue}#{query.totalPriceCurrency}. #{query.url}"
