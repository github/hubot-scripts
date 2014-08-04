# Description:
#   Sometimes you gotta ssh into a server and do something.
#   This script has a sweet method that runs an arbitrary ssh command
#   on a remote server. In real life you'll probably want to explicitly
#   specify what hubot  does via ssh instead of leaving it wide open in your
#   chat room. This script is a great starting point.
#
# Dependencies:
#   "ssh2": "0.2.14"
#
# Configuration:
#   HUBOT_SSH_PRIVATE_KEY_PATH (absolute path on machine running hubot)
#   HUBOT_SSH_PRINT_DEBUG_CONNECTION_INFO (set to true or false)
#
# Commands:
#   hubot ssh username host command_to_run - run a command on a host via ssh
#
# Author:
#   veloandy
#######################

#######################
Connection = require('ssh2')
keypath = process.env.HUBOT_SSH_PRIVATE_KEY_PATH
debug_str = process.env.HUBOT_SSH_PRINT_DEBUG_CONNECTION_INFO
send_debug_msgs = /true/i.test(debug_str)

module.exports = (robot) ->
  robot.respond /ssh ([\w.-]*) ([\w.-]*) (.*)/i, (msg) ->
    user = msg.match[1]
    host = msg.match[2]
    command = msg.match[3]
    runCommandViaSsh(msg, user, host, keypath, command, send_debug_msgs)

runCommandViaSsh = (msg, remote_user, remote_host, key_file, command, debug) ->
  try
    c = new Connection()
    c.on 'connect', ->
      msg.send('Connection :: connect') if debug

    c.on 'ready', ->
      msg.send('Connection :: ready') if debug
      c.exec command, (err, stream) ->
        throw err  if err
        stream.on 'data', (data, extended) ->
          if debug
            if extended is 'stderr'
              output_type='STDERR: '
            else
              output_type='STDOUT: '
            msg.send(output_type + data)
          else
            msg.send(data)

        stream.on 'end', ->
          msg.send('Stream :: EOF') if debug

        stream.on 'close', ->
          msg.send('Stream :: close') if debug

        stream.on 'exit', (code, signal) ->
          if debug
            msg.send('Stream :: exit :: code: ' + code + ', signal: ' + signal)
          c.end()

    c.on 'error', (err) ->
      msg.send('Connection :: error :: ' + err)

    c.on "end", ->
      msg.send('Connection :: end') if debug

    c.on 'close', (had_error) ->
      msg.send('Connection :: close') if debug

    c.connect
      host: remote_host
      port: 22
      username: remote_user
      privateKey: require('fs').readFileSync(key_file)
  catch e
    msg.send('Caught Exception: ' + e)
