# Load scripts from the hubot scripts directory on the fly for testing purposes.
#
# script load <script> - Load a script
# script list [-l]     - List all availiable scripts (optional -l for list mode)
# script info <script> - Print script help

# Examples
#
#   script load xkcd
#   # => Loading scripts XKCD
#        xkcd       - The latest XKCD comic
#        xkcd <num> - XKCD comic matching the supplied number
#
#   script list
#   # => achievement_unlocked, adult, animal, ..., wolfram, wordnik, xkcd
#
#   script list -l
#   # => achievement_unlocked
#        adult
#        animal
#        ...
#        wolfram
#        wordnik
#        xkcd
#
#   script info xkcd
#   # => xkcd       - The latest XKCD comic
#        xkcd <num> - XKCD comic matching the supplied number
#
# Note
#
#   1. Any scripts that you load will be lost on bot restart unless you add
#      them to `hubot-scripts.json`.
#   2. If this script is enabled ANYBODY will be able to load scripts, you may
#      not want to leave this script enabled.
#
# Authors
#
#   Tim Oxley   @secoif
#   Odin Dutton @twe4ked
#
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
