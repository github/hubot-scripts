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
#   unix mail client installed on the system

util = require 'util'
child_process = require 'child_process'

module.exports = (robot) ->
  emailTime = null
  sendEmail = (recipients, subject, msg, from) ->
    mailArgs = ['-s', subject, '-a', "From: #{from}", '--']
    mailArgs = mailArgs.concat recipients
    p = child_process.execFile 'mail', mailArgs, {}, (error, stdout, stderr) ->
      util.print 'stdout: ' + stdout
      util.print 'stderr: ' + stderr
    p.stdin.write "#{msg}\n"
    p.stdin.end()

  robot.respond /email (.*) -s (.*) -m (.*)/i, (msg) ->
    sendEmail msg.match[1].split(" "), msg.match[2], msg.match[3], msg.message.user.id
    msg.send "email sent"
