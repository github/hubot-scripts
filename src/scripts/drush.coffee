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
#   to the spawn method; however, being that is a colossal security risk, I opted to limit the commands that
#   can be executed as well as the options provided to those commands. By default this is limited to
#   relatively harmless "info" commands.
#
# Commands:
#   hubot drush sa - show the list of available sites ( --update-aliases will refresh this list )
#   hubot drush rq - show pending core requirements at a warning level or above
#   hubot drush <site alias> cc - Clears "all" cache for a given site alias.
#   hubot drush <site alias> pml - Lists the site modules ( "enabled" and "non-core" by default this can be changed with --disbaled or --core )
#   hubot drush <site alias> pmi <module/theme> - Show detailed info about a module or theme
#   hubot drush <site alias> uinf <user> - Display information about the user specified by uid, email, or username
#   hubot drush <site alias> ws - Show the 10 most recent watchdog messages
#   hubot drush <site alias> vget <variable name> - Show the value of a given variable
#
# Author:
#   rh0

spawn = require("child_process").spawn

drush_interface = ->
  site_aliases = []

  # helper method to propagate the site aliases in memory
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

  # run the update script
  update_aliases()

  # generalized spawn method
  execute_drush = (msg, drush_args) ->
    output = ''
    msg.send "This may take a moment..."
    drush_spawn = spawn("drush", drush_args)
    drush_spawn.stdout.on "data", (data) ->
      output += data
    drush_spawn.stderr.on "data", (data) ->
      output += data
    drush_spawn.on "exit", (code) ->
      output += "Command complete."
      msg.send output

  # the commands that we are allowing drush to execute
  # NOTE: If you decide to augment the commands here please carefully consider what you are opening to the people
  #       interacting with hubot.
  allowed_commands =
    drush_sa: (msg, command) ->
      if command.args.indexOf('--update-aliases') is -1
        msg.send "If this list is empty or has unexpected results update aliases ('drush sa --update-aliases')."
        msg.send "Aliases we have in memory:\n" + site_aliases.join("\n")
      else
        msg.send "Updating aliases..."
        update_aliases(msg)

    drush_cc: (msg, command) ->
      execute_drush(msg, [command.alias, "cc", "all"])

    drush_rq: (msg, command) ->
      execute_drush(msg, [command.alias, "rq", "--severity=1"])

    drush_pml: (msg, command) ->
      allowed_options = ["--status=enabled", "--status=disabled", "--no-core", "--core"]
      filtered_options = command.args.filter((elem) ->
        allowed_options.indexOf(elem) isnt -1
      )
      filtered_options.unshift(command.alias, "pml")
      execute_drush(msg, filtered_options)

    drush_uinf: (msg, command) ->
      user_search = command.args.shift()
      execute_drush(msg, [command.alias, "uinf", user_search])

    drush_pmi: (msg, command) ->
      extension_search = command.args.shift()
      execute_drush(msg, [command.alias, "pmi", extension_search])

    drush_ws: (msg, command) ->
      allowed_options = ["--full"]
      filtered_options = command.args.filter((elem) ->
        allowed_options.indexOf(elem) isnt -1
      )
      filtered_options.unshift(command.alias, "ws")
      execute_drush(msg, filtered_options)

    drush_vget: (msg, command) ->
      variable_search = command.args.shift()
      # forcing this to --exact to prevent channel flood from a huge search
      execute_drush(msg, [command.alias, "vget", variable_search, "--exact"])

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
      unless verify_alias(site_alias.slice(1)) is false
        command_suff = extra_args.shift()
      else
        `undefined`
    # Kind of gross but the site-alias command is the only one that does not need a site alias
    # so let's check before we fire up drush to fail.
    else unless site_alias is "sa"
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

  # The main method, fire this when we receive a "drush " command.
  execute: (msg) ->
    command = parse_command(msg.match[1])
    unless command is `undefined`
      allowed_commands[command.cmnd](msg, command)
    else
      msg.send "'drush " + msg.match[1] + "' is and invalid command. Please try again."

# Instantiate the drush interface
drush = drush_interface()

# Hook in with hobot
module.exports = (robot) ->
  robot.respond /drush (.*)$/i, (msg) ->
    drush.execute(msg)
