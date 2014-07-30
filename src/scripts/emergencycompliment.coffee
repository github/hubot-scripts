# Description
#   Receive a compliment, for those days you're feeling down. Sourced from emergencycompliment.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot compliment me - Receive a compliment.
#
# Author:
#   emarref

module.exports = (robot) ->

  phraseMatcher = /"phrase":"(.*)",\n/gm

  robot.respond /compliment me/, (msg) ->
    robot.http('http://emergencycompliment.com/js/compliments.js').get() (err, res, body) ->
      if err or res.statusCode isnt 200
        robot.logger.error res.statusCode, err
        return
      compliments = []
      while compliment = phraseMatcher.exec(body)
        compliments.push compliment[1]
      robot.logger.info "Found #{compliments.length} compliments"
      msg.reply msg.random compliments
