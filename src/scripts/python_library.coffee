# Description:
#   Allows hubot to get the link to a Python 2 or 3 libaray.
#
# Dependencies:
#   None
#
# Commands:
#   hubot python(2|3) library <name> - Gets the url of the named library if it exists.
#
# Author:
#   Bryce Verdier (btv)

module.exports = (robot) ->
  robot.respond /python(2|3) library (.*)/i, (msg) ->
      matches = msg.match
      libraryMe robot, matches[1], matches[2], (text) ->
          msg.send text

libraryMe = (robot, version, lib, callback) ->
    url = "http://docs.python.org/#{version}/library/#{lib}.html"
    robot.http(url)
         .get() (err,res,body) ->
             if res.statusCode != 200
                 callback "MERP! The library #{lib} does not exist!"
             else
                 callback url

