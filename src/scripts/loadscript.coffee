# Learns bot new scripts while running
#
# learn <url to a script> - Downloads into deploy-local scripts and loads it.

Path = require 'path'
Fs   = require 'fs'

module.exports = (robot) ->
  robot.respond /learn (https?.*\.(coffee|js))/i, (msg) ->
    url = msg.match[1]
    name = Path.basename url
    unless dynamicScript.exists name
      msg.http(url).get() (err, res, body) ->
        if res.statusCode is 200
          dynamicScript.load robot, name, body
          msg.reply "Done"
        else
          msg.reply "Sorry, I couldn't find that script"
    else
      msg.reply "I already know this, perhaps I should relearn it?"

deployLocalScriptsPath = Path.resolve "./scripts"

dynamicScript =
  exists: (scriptName) ->
    scriptName in Fs.readdirSync deployLocalScriptsPath

  path: (scriptName) ->
    Path.resolve deployLocalScriptsPath, scriptName

  load: (robot, scriptName, body) ->
    foo = Fs.writeFileSync @path(scriptName), body
    robot.loadFile deployLocalScriptsPath, scriptName
