# Description
#   Grab web screens/thumbs of URLs using the capgun.io service
#
#   Requires a CapGun API token to be set in the env var HUBOT_CAPGUN_TOKEN
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_CAPGUN_TOKEN
#
# Commands:
#   hubot cap <url> - Get a web screen of the url
#
# Notes:
#   none
#
# Author:
#   monde

module.exports = (robot) ->
  robot.respond /cap (.*)/i, (msg) ->
    Capgun.start msg, msg.match[1]

Capgun =

  interval: 2500

  token: process.env.HUBOT_CAPGUN_TOKEN

  start: (msg, url) ->
    this.submitOrder(msg, url)

  submitOrder: (msg, url) ->
    capgun = this
    data = JSON.stringify({"url": url})
    msg.http('https://api.capgun.io/v1/orders.json')
      .headers
        'Authorization': capgun.token,
        'Accept': 'application/json'
      .post(data) (err, res, body) ->
        result = JSON.parse(body)
        if err || res.statusCode != 200
          message = result.message || "???"
          msg.send "Capgun job failed with message '" + message + "', I'm bailing out!"
        else
          setTimeout (-> capgun.checkJob(msg, url, result.order.id, 0)), capgun.interval

  checkJob: (msg, url, order_id, duration) ->
    capgun = this

    if duration > 90000
      msg.send "Capgun job hung past 90 seconds for URL " + url + " , I'm bailing out!"
    else
      msg.http('https://api.capgun.io/v1/orders/' + order_id + '.json')
        .headers
          'Authorization': capgun.token,
          'Accept': 'application/json'
        .get() (err, res, body) ->
          result = JSON.parse(body)
          state = result.order.job.state

          if state.search(/failed/) >= 0
            msg.send "Capgun order " + order_id + " failed for URL " + url
          else if state.search(/completed/) >= 0
            msg.send result.order.asset_urls['xlarge']
          else
            setTimeout (-> capgun.checkJob(msg, url, result.order.id, duration + capgun.interval)), capgun.interval