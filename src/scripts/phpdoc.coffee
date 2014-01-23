# Description:
#   PHP's functions reference.
#
# Dependencies:
#   "cheerio": ""
#
# Configuration:
#   None
#
# Commands:
#   hubot phpdoc for <function> - Shows PHP function information.
#
# Authors:
#   nebiros
#   Carter McKendry

module.exports = (robot) ->
  robot.respond /phpdoc for (.+)$/i, (msg) ->
    msg
      .http("http://www.php.net/manual/en/function." + msg.match[1].replace(/[_-]+/, "-") + ".php")
      .get() (err, res, body) ->

        $ = require("cheerio").load(body)
        ver = $(".refnamediv p.verinfo").text()
        desc = $(".refnamediv span.dc-title").text()
        syn = $(".methodsynopsis").text().replace(/\s+/g, " ").replace(/(\r\n|\n|\r)/gm, " ")

        if ver and desc and syn
          msg.send "#{ver} - #{desc}"
          msg.send syn
        else
          msg.send "Not found."
