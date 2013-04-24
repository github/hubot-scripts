# Description:
#   Playing with Drush integration. Simple implementation of informational drush commands, and a base
#   interface for further drush command integration.
#
# Dependencies:
#   None
#
# Configuration:
#   The hubot user will need permissions to run drush on the server that it is installed on.
#   If the site aliases are to remote servers (likely the case) then the hubot user will also need
#   ssh keys setup in order to access these sites.
#
# Notes:
#   It would have been easier and more elegant to simply allow the user to funnel drush commands directly
#   to the spawn method.  However that is a colossal security risk, so I opted to limit the commands that
#   can be executed as well as the options provided to those commands.
#
# Commands:
#   hubot drush sa - show the list of available sites ( --update-aliases will refresh this list )
#   hubot drush rq - show pending core requirements at a warning level or above
#   hubot drush <site alias> cc - Clears 'all' cache for a given site alias.
#   hubot drush <site alias> pml - Lists the site modules ( "enabled" and "non-core" by default this can be changed with --disbaled or --core )
#
# Author:
#   rh0

util = require("util")
spawn = require("child_process").spawn

drush_interface = ->
  site_aliases = []
  #allowed_commands = ["sa", "cc", "pml", "uinf", "pmi", "ws", "vget", "rq"]

  # helper method to propigate the site aliases in memory
  update_aliases = (msg) ->
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
        output = "Alias update complete."
      unless msg is `undefined`
        msg.send output

  # run the update script upon construction
  update_aliases()

  allowed_commands =
    drush_sa: (msg, command) ->
      if command.args.indexOf('--update-aliases') is -1
        msg.send "If this list is empty or has unexpected results update aliases ('drush sa --update-aliases')."
        msg.send "Aliases we have in memory:\n" + site_aliases.join("\n")
      else
        msg.send "Updating aliases..."
        update_aliases(msg)

    drush_cc: (msg, command) ->
      output = ''
      msg.send "This may take a moment..."
      clearcache = spawn("drush", [command.alias, "cc", "all"])
      clearcache.stdout.on "data", (data) ->
        output += data
      clearcache.stderr.on "data", (data) ->
        output += data
      clearcache.on "exit", (code) ->
        if code is 0
          output += "Cache clear complete."
        msg.send output

    drush_rq: (msg, command) ->
      output = ''
      msg.send "This may take a moment..."
      clearcache = spawn("drush", [command.alias, "rq", "--severity=1"])
      clearcache.stdout.on "data", (data) ->
        output += data
      clearcache.stderr.on "data", (data) ->
        output += data
      clearcache.on "exit", (code) ->
        if code is 0
          output += "Core Requirements complete."
        msg.send output

    drush_pml: (msg, command) ->
      output = ''
      modules_state = "--status=enabled"
      modules_core = "--no-core"
      unless command.args.indexOf("--disabled") is -1
        modules_state = "--status=disabled"
      unless command.args.indexOf("--core") is -1
        modules_core = "--core"

      msg.send "This may take a moment..."

      spawn_options = [command.alias, "pml", modules_state, modules_core]
      pml = spawn("drush", spawn_options)
      pml.stdout.on "data", (data) ->
        output += data
      pml.stderr.on "data", (data) ->
        output = "We've experienced and error fetching module list."
      pml.on "exit", (code) ->
        if code is 0
          output += "Module list complete."
        msg.send output

  # verify alias before firing the command, saves us time on waiting for an err from drush
  verify_alias = (check_alias) ->
    if site_aliases.indexOf(check_alias) is -1
      false
    else
      true

  # parsing the user input after "drush "
  parse_command = (user_command) ->
    extra_args = user_command.split(' ')
    site_alias = extra_args.shift()
    command_suff = ''
    if site_alias.charAt(0) is "@"
      unless verify_alias(site_alias) is false
        command_suff = extra_args.shift()
      else
        `undefined`
    else
      command_suff = site_alias
      site_alias = ''
    command = "drush_" + command_suff
    if typeof allowed_commands[command] is "function"
      return (
        cmnd: command
        alias: site_alias
        args: extra_args
      )
    else
      `undefined`

  # BEGIN public facing methods

  # The main method, fire this when we recieve a "drush " command.
  execute: (msg) ->
    command = parse_command(msg.match[1])
    unless command is `undefined`
      allowed_commands[command.cmnd](msg, command)
    else
      msg.send "'drush " + msg.match[1] + "' is and invalid command. Please try again."

# Instanciate the drush interface
drush = drush_interface()

# Hook in with hobot
module.exports = (robot) ->
  robot.respond /drush (.*)$/i, (msg) ->
    drush.execute(msg)
