# Description:
#   PHP's functions reference.
#
# Dependencies:
#   "jsdom": ""
#   "jquery": ""
#
# Configuration:
#   None
#
# Commands:
#   hubot phpdoc for <function> - Shows PHP function information.
#
# Author:
#   nebiros

jsdom = require("jsdom").jsdom

module.exports = (robot) ->
  robot.respond /phpdoc for (.+)$/i, (msg) ->
    msg
      .http("http://www.php.net/manual/en/function." + msg.match[1].replace(/[_-]+/, "-") + ".php")
      .get() (err, res, body) ->
        window = (jsdom body, null,
          features:
            FetchExternalResources: false
            ProcessExternalResources: false
            MutationEvents: false
            QuerySelector: false
        ).createWindow()

        $ = require("jquery").create(window)
        ver = $.trim $(".refnamediv p.verinfo").text()
        desc = $.trim $(".refnamediv span.dc-title").text()
        syn = $.trim $(".methodsynopsis").text().replace(/\s+/g, " ").replace(/(\r\n|\n|\r)/gm, " ")

        if ver and desc and syn
          msg.send "#{ver} - #{desc}"
          msg.send syn
        else
          msg.send "Not found."