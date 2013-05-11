# Description:
#   Load scripts from the hubot scripts directory on the fly for testing purposes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot script load <script> - Load a script
#   hubot script list [-l]     - List all availiable scripts (optional -l for list mode)
#   hubot script info <script> - Print script help
#
# Author:
#   unitio

Path = require 'path'
Fs   = require 'fs'

module.exports = (robot) ->

  # Private: Print help for a script
  printHelp = (script, msg) ->
    path = Path.resolve('node_modules', 'hubot-scripts', 'src', 'scripts')
    # Call parseHelp on tmpRobot with custom array push, so we can capture the
    # commands as they are added, there's no other way to access the populated
    # commands array.
    tmpRobot =
      logger: 
        debug: (debug_msg)->
          null
      documentation: {}
      commands:
        push: (command) ->
          msg.send(command)
    robot.parseHelp.call(tmpRobot, Path.join path, "#{script}.coffee")

  # Load a script
  robot.respond /script load (.*)$/i, (msg) ->
    script = msg.match[1]
    scriptPath = require.resolve(Path.resolve('node_modules', 'hubot-scripts', 'src', 'scripts', script))

    printHelp(script, msg)
    robot.loadFile(Path.dirname(scriptPath), Path.basename(scriptPath))

  # List all available scripts
  robot.respond /script list\s?(-l)?/i, (msg) ->
    Fs.readdir Path.resolve('node_modules', 'hubot-scripts', 'src', 'scripts'), (err, files) ->
      msg.send 'An error occurred' if err
      listMode = msg.match[1]?
      scripts = for file in files
        Path.basename(file, '.coffee')

      if listMode
        msg.send scripts.join('\n')
      else
        msg.send scripts.join(', ')

  # Print script help
  robot.respond /script info (.*)/i, (msg) ->
    script = msg.match[1]
    printHelp(script, msg)
