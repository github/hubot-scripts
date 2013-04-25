# Description:
#   Show some help to git noobies
#
# Dependencies:
#   jsdom
#   jquery
#
# Configuration:
#   None
#
# Commands:
#   git help <topic>
#
# Author:
#   vquaiato, Jens Jahnke

jsdom = require("jsdom").jsdom

module.exports = (robot) ->
  robot.respond /git help (.+)$/i, (msg) ->
    topic = msg.match[1].toLowerCase()

    url = 'http://git-scm.com/docs/git-' + topic
    msg.http(url).get() (err, res, body) ->
      window = (jsdom body, null,
        features:
          FetchExternalResources: false
          ProcessExternalResources: false
          MutationEvents: false
          QuerySelector: false
      ).createWindow()

      $ = require("jquery").create(window)
      name = $.trim $('#header .sectionbody .paragraph').text()
      desc = $.trim $('#_synopsis + .sectionbody').text()

      if name and desc
        msg.send name
        msg.send desc
        msg.send "See #{url} for details."
      else
        msg.send "No git help page found for #{topic}."
