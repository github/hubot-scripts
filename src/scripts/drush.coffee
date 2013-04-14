# Description:
#   Playing with Drush integration.
#
# Commands:
#   hubot drush cc <site alias> - Clears the cache for a given site alias.

util = require("util")
spawn = require("child_process").spawn

drush_interface = ->
  site_aliases = []
  allowed_commands = ["sa", "cc", "pml", "unif", "pmi", "ws", "vget", "rq"]

  # Our allowed commands
  commands =
    drush_sa: (msg) ->
      msg.send "Aliases we have in memory, if this list is empty or is unexpected update aliases."
      msg.send site_aliases.join("\n")

  # parsing the user input after "drush "
  parse_command = (user_command) ->
    args = user_command.split(' ')
    command = "drush_" + args.shift()
    if typeof commands[command] is "function"
      return (
        cmnd: command
        extra_args: args
      )
      command
    else
      `undefined`

  # Begin our public facing methods
  update_aliases: (msg) ->
    output = ''
    raw_aliases = ''
    fetch_aliases = spawn("drush", ["sa"])
    fetch_aliases.stdout.on "data", (data) ->
      raw_aliases += data
    fetch_aliases.stderr.on "data", (data) ->
      output = "Update experienced an error: " + data
    fetch_aliases.on "exit", (code) ->
      if code is 0
        site_aliases = raw_aliases.split('\n')
        output = "drush aliases updated"
      unless msg is `undefined`
        msg.send output

  # The main method, fire this when we recieve a "drush " command.
  execute: (msg) ->
    msg.send "we got args: " + msg.match[1]
    command = parse_command(msg.match[1])
    unless command is `undefined`
      commands[command.cmnd](msg)
    else
      msg.send "'drush " + msg.match[1] + "' is and invalid command. Please try again."

drush = drush_interface()
drush.update_aliases()

module.exports = (robot) ->
  robot.respond /drush (.*)$/i, (msg) ->
    msg.send "drush fired!"
    drush.execute(msg)

#module.exports = (robot) ->
#  robot.respond /drush sa$/i, (msg) ->
#    #    if not process.env.DRUSH_UID?
#    # msg.send "DRUSH_UID is not set. Cannot complete this action."
#    #  return
#
#    sitelist = 'Site Aliases Available: \n'
#    sitealias = spawn("drush", ["sa"])
#    sitealias.stdout.on "data", (data) ->
#      sitelist = sitelist + data
#
#    sitealias.on "exit", (code) ->
#      msg.send sitelist
#      msg.send 'sa command complete.'
#
#  robot.respond /drush cc (.*)$/i, (msg) ->
#    ccout = ''
#    clearcache = spawn("drush", [msg.match[1], "cc", "all"])
#    msg.send "This may take a minute, please be patient..."
#    clearcache.stdout.on "data", (data) ->
#      ccout = ccout + data
#
#    clearcache.stderr.on "data", (data) ->
#      ccout = ccout + data
#
#    clearcache.on "exit", (code) ->
#      if code is 0
#        msg.send ccout
#        msg.send "--== command complete ==--"
#      else
#        msg.send "Drush experienced and error."
#
#  robot.respond /drush pml (.*)$/i, (msg) ->
#    pmlOut = '\n'
#    pml = spawn("drush", [msg.match[1], "pml", "--status=enabled", "--no-core"])
#    pml.stdout.on "data", (data) ->
#      pmlOut = pmlOut + data
#    pml.stderr.on "data", (data) ->
#      pmlOut = pmlOut + data
#    pml.on "exit", (code) ->
#      msg.send pmlOut
#      msg.send "--== command complete ==--"

