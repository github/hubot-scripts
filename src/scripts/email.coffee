# Description:
#   Email from hubot to any address
#
# Dependencies:
#   "nodemailer": "0.6.1"
#
# Configuration:
#   HUBOT_EMAIL_TRANSPORT - selected transport type (@see https://github.com/andris9/Nodemailer#possible-transport-methods)
#   HUBOT_EMAIL_OPTIONS - JSON string of mail options (@see https://github.com/andris9/Nodemailer#possible-transport-methods)
#   HUBOT_EMAIL_FROM - sender email address
#
# Commands:
#   hubot email <user@email.com> -s <subject> -m <message> - Sends email with the <subject> <message> to address <user@email.com>
#   hubot emailDebug <user@email.com> -s <subject> -m <message> - Operates the same as 'email', but provides detailed output for debugging configuration
#
# Notes:
#   The above configuration and dependencies are only necessary if you don't have a unix mail client available
#   or you want to use your own SMTP, SES or other service provided through 'nodemailer'. If you exclude the
#   configuration above, it will default to the unix mail client.
#
# Author:
#   earlonrails
#   wintondeshong
#
# Additional Requirements
#   unix mail client installed on the system (if you aren't using nodemailer)

util = require 'util'
childProcess = require 'child_process'
transportType = process.env.HUBOT_EMAIL_TRANSPORT
nodemailerOptions = process.env.HUBOT_EMAIL_OPTIONS
fromAddress = process.env.HUBOT_EMAIL_FROM
isDebugMode = false

module.exports = (robot) ->
  emailTime = null

  api =
    msg: null

    output: (standardMessage, debugDetails = null, isOnlyDebug = false) ->
      if (not isDebugMode or not debugDetails?) and not isOnlyDebug
        @msg.send standardMessage
      if isDebugMode and debugDetails?
        @msg.send "#{standardMessage}: #{util.inspect(debugDetails)}"

    configureMailOptions: (recipients, subject, body, from) ->
      return {
        from: from
        to: recipients.join ", "
        subject: subject
        text: body
        html: body
      }

    sendNodeMail: (options) ->
      mailerOptions = JSON.parse(nodemailerOptions)
      @output 'Node Mailer Options', mailerOptions, true
      transport = require('nodemailer').createTransport transportType, mailerOptions
      @output 'Node Mailer Object', transport, true
      @output 'Sending...'
      transport.sendMail options, (error, response) =>
        if error
          @output 'Error delivering message', error
        else
          @output 'Message sent', response.message
        transport.close()

    sendUnixMail: (options) ->
      mailArgs = ['-s', options.subject, '-a', "From: #{options.from}", '--']
      mailArgs = mailArgs.concat options.recipients
      p = childProcess.execFile 'mail', mailArgs, {}, (error, stdout, stderr) ->
        util.print 'stdout: ' + stdout
        util.print 'stderr: ' + stderr
      p.stdin.write "#{options.body}\n"
      p.stdin.end()
      @output "Email sent"

    sendEmail: (msg) ->
      @msg = msg
      mailMode = if transportType? then 'Node' else 'Unix'
      from = if transportType? then fromAddress else msg.message.user.id
      mailOptions = @configureMailOptions msg.match[1].split(' '), msg.match[2], msg.match[3], from
      @output 'Mail Options', mailOptions, true
      @["send#{mailMode}Mail"](mailOptions)

  robot.respond /email (.*) -s (.*) -m (.*)/i, (msg) ->
    isDebugMode = false
    api.sendEmail msg

  robot.respond /emailDebug (.*) -s (.*) -m (.*)/i, (msg) ->
    isDebugMode = true
    api.sendEmail msg
