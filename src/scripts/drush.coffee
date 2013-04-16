# Description:
#   Playing with Drush integration.
#
# Commands:
#   hubot drush cc <site alias> - Clears the cache for a given site alias.

util = require("util")
spawn = require("child_process").spawn

drush_interface = ->
  site_aliases = []
  #allowed_commands = ["sa", "cc", "pml", "unif", "pmi", "ws", "vget", "rq"]

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
      msg.send "This may take a minute..."
      clearcache = spawn("drush", [command.alias, "cc", "all"])
      clearcache.stdout.on "data", (data) ->
        output += data
      clearcache.stderr.on "data", (data) ->
        output = "We've experienced and error clearing cache."
      clearcache.on "exit", (code) ->
        if code is 0
          output += "Cache clear complete."
        msg.send output

#   drush_pml: (msg, command) ->
#     output = ''
#     # @TODO loop through command.args and append args that appear in allowed_options
#     allowed_options = ['--enabled', '--disabled', '--core', '--no-core']
#     spawn_options = [command.alias, "pml", "--pipe"]
#     pml = spawn("drush", [command.alias, "pml", "--status=enabled", "--no-core"])

  # parsing the user input after "drush "
  parse_command = (user_command) ->
    extra_args = user_command.split(' ')
    site_alias = extra_args.shift()
    command_suff = ''
    if site_alias.charAt(0) is "@"
      command_suff = extra_args.shift()
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
    msg.send "drush fired!"
    drush.execute(msg)
