# Description:
#   evaluate code
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot eval me <lang> <code> - evaluate <code> and show the result
#   hubot eval on <lang> - start recording
#   hubot eval off|finish|done - evaluate recorded <code> and show the result
#   hubot eval cancel - cancel recording
#
# Author:
#   aanoaa

module.exports = (robot) ->
  robot.respond /eval[,:]? +on +([a-z]+) *$/i, (msg) ->
    robot.brain.data.eval or= {}
    robot.brain.data.eval[msg.message.user.name] = {
      recording: true
      lang: msg.match[1]
    }
    msg.send("OK, recording #{msg.message.user.name}'s codes for evaluate.")

  robot.respond /eval[,:]? +(?:off|finish|done) *$/i, (msg) ->
    return unless robot.brain.data.eval?[msg.message.user.name]?.recording
    code = robot.brain.data.eval[msg.message.user.name].code?.join("\n")
    lang = robot.brain.data.eval[msg.message.user.name].lang
    msg
      .http("http://api.dan.co.jp/lleval.cgi")
      .query(s: "#!/usr/bin/#{lang}\n#{code}")
      .get() (err, res, body) ->
        out = JSON.parse(body)
        ret = out.stdout or out.stderr
        msg.send ret.split("\n")
    delete robot.brain.data.eval[msg.message.user.name]

  robot.respond /eval[,:]? +cancel *$/i, (msg) ->
    delete robot.brain.data.eval?[msg.message.user.name]?
    msg.send "canceled #{msg.message.user.name}'s evaluation recording"

  robot.respond /eval( me)? ([^ ]+) (.+)/i, (msg) ->
    return if msg.match[2] in ['on', 'off', 'finish', 'done', 'cancel']
    msg
      .http("http://api.dan.co.jp/lleval.cgi")
      .query(s: "#!/usr/bin/#{msg.match[2]}\n#{msg.match[3]}")
      .get() (err, res, body) ->
        out = JSON.parse(body)
        ret = out.stdout or out.stderr
        msg.send ret.split("\n")

  robot.catchAll (msg) ->
    return unless robot.brain.data.eval?[msg.message.user.name]
    if robot.brain.data.eval[msg.message.user.name].recording
      robot.brain.data.eval[msg.message.user.name].code or= []
      unless msg.message.text?.match /eval[,:]? +on +([a-z]+) *$/i
        robot.brain.data.eval[msg.message.user.name].code.push msg.message.text
