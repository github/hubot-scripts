# Description:
#   None
#
# Dependencies:
#   "jsdom": "0.2.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot whatis <term> - search the term on urbandictionary.com and get a random popular definition for the term.
#
# Author:
#   Kevin Qiu
#
# FIXME merge with urban.coffee

jsdom = require('jsdom').jsdom

module.exports = (robot) ->
  robot.respond /whatis (.+)$/i, (msg) ->
    msg
      .http('http://www.urbandictionary.com/define.php?term=' + (encodeURIComponent msg.match[1]))
      .get() (err, res, body) ->
        window = (jsdom body, null,
          features :
            FetchExternalResources : false
            ProcessExternalResources : false
            MutationEvents : false
            QuerySelector : false
        ).createWindow()

        $ = require('jquery').create(window)

        definitions = []
        $(".meaning").each (idx, item) ->
          definitions.push $(item).text()

        msgText = if definitions.length==0 then "No definition found." else (msg.random definitions)
        msg.send msgText
