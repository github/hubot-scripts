# Description:
#   Look up npm package versions
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot npm version <package name> - returns npm package version if it exists
#
# Author:
#   redhotvengeance

HtmlParser = require "htmlparser"
Select     = require("soupselect").select

module.exports = (robot) ->
  robot.respond /npm version (.*)/i, (msg) ->
    packageName = escape(msg.match[1])
    msg.http("https://www.npmjs.org/package/#{packageName}").get() (err, res, body) ->
      if err
        msg.send "I tried talking to npmjs.org, but it seems to be ignoring me."
      else
        if res.statusCode is 200
          handler = new HtmlParser.DefaultHandler()
          parser  = new HtmlParser.Parser handler

          parser.parseComplete body

          metaData = Select(handler.dom, ".metadata")

          versionString = metaData[0].children[3].children[3].children[1].children[0].data.toString()
          versionArray = versionString.match(/([0-9.])/ig)

          version = ''

          for digit in versionArray then do (digit) =>
            version += digit

          msg.send "It looks like #{packageName} is at version #{version}."
        else
          msg.send "It looks like #{packageName} doesn't exist."
