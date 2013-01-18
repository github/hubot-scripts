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
#   hubot eval list - list available languages
#
# Author:
#   aanoaa

util = require 'util'
ready = false

module.exports = (robot) ->
  get_languages = (robot, callback) ->
    callback or= () ->
    if not ready or robot.brain?.data?.eval_langs
      callback(robot.brain?.data?.eval_langs || {})
      return

    url = "http://api.dan.co.jp/lleval.cgi"
    robot.logger.info "Loading language data from #{url}"
    robot
      .http(url)
      .query(q: "1")
      .get() (err, res, body) ->
        langs = JSON.parse(body)
        robot.brain.data.eval_langs = langs
        callback(langs)
        robot.logger.info "Brain received eval language list #{util.inspect(langs)}"

  lang_valid = (robot, lang, callback) ->
    callback or= () ->
    get_languages robot, (languages) ->
      for own id, desc of languages
        if lang == id
          callback(true)
          return
      callback(false)

  robot.brain.on 'loaded', ->
    ready = true
    get_languages robot

  robot.respond /eval[,:]?\s+list$/i, (msg) ->
    get_languages robot, (languages) ->
      lang_msg = 'Known Languages\n\n'
      for own id, desc of languages
        lang_msg += "#{id}: #{desc}\n"
      msg.send lang_msg

  robot.respond /eval[,:]? +on +([a-z]+) *$/i, (msg) ->
    robot.brain.data.eval or= {}
    lang = msg.match[1]
    
    is_valid = (valid) ->
      if not valid 
        msg.send "Unknown language #{lang} - use eval list command for languages"
        return

      robot.brain.data.eval[msg.message.user.name] = {
        recording: true
        lang: msg.match[1]
      }
      msg.send("OK, recording #{msg.message.user.name}'s codes for evaluate.")

    lang_valid robot, lang, is_valid

  robot.respond /eval[,:]? +(?:off|finish|done) *$/i, (msg) ->
    return unless robot.brain.data.eval?[msg.message.user.name]?.recording
    code = robot.brain.data.eval[msg.message.user.name].code?.join("\n")
    lang = robot.brain.data.eval[msg.message.user.name].lang
    
    is_valid = (valid) ->
      if not valid
        msg.send "Unknown language #{lang} - use eval list command for languages"
        return

      msg
        .http("http://api.dan.co.jp/lleval.cgi")
        .query(s: "#!/usr/bin/#{lang}\n#{code}")
        .get() (err, res, body) ->
          out = JSON.parse(body)
          ret = out.stdout or out.stderr
          msg.send ret.split("\n")
      delete robot.brain.data.eval[msg.message.user.name]

    lang_valid(robot, lang, is_valid)

  robot.respond /eval[,:]? +cancel *$/i, (msg) ->
    delete robot.brain.data.eval?[msg.message.user.name]?
    msg.send "canceled #{msg.message.user.name}'s evaluation recording"

  robot.respond /eval( me)? ([^ ]+) (.+)/i, (msg) ->
    lang = msg.match[2]
    return if lang in ['on', 'off', 'finish', 'done', 'cancel']

    is_valid = (valid) ->
      if not valid
        msg.send "Unknown language #{lang} - use eval list command for languages"
        return

      msg
        .http("http://api.dan.co.jp/lleval.cgi")
        .query(s: "#!/usr/bin/#{lang}\n#{msg.match[3]}")
        .get() (err, res, body) ->
          out = JSON.parse(body)
          ret = out.stdout or out.stderr
          msg.send ret.split("\n")

    lang_valid(robot, lang, is_valid)

  robot.catchAll (msg) ->
    return unless robot.brain.data.eval?[msg.message.user.name]
    if robot.brain.data.eval[msg.message.user.name].recording
      robot.brain.data.eval[msg.message.user.name].code or= []
      unless msg.message.text?.match /eval[,:]? +on +([a-z]+) *$/i
        robot.brain.data.eval[msg.message.user.name].code.push msg.message.text
