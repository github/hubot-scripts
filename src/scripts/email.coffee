# Description:
#   Email from hubot to any address
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot email <user@email.com> -s <subject> -m <message> - Sends email with the <subject> <message> to address <user@email.com>
#
# Author:
#   earlonrails
#
# Additional Requirements
#   Mutt email installed on the system

sys = require 'sys'
child_process = require 'child_process'
exec = child_process.exec

module.exports = (robot) ->
  emailTime = null
  sendEmail = (addresses, subject, msg) ->
    muttCommand = """echo '#{msg}' | mutt -s '#{subject}' -- #{addresses}"""
    exec muttCommand, (error, stdout, stderr) ->
      sys.print 'stdout: ' + stdout
      sys.print 'stderr: ' + stderr

  robot.respond /email (^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$) -s (.*) -m (.*)/i, (msg) ->
    sendEmail msg.match[0], msg.match[1], msg.match[2]
