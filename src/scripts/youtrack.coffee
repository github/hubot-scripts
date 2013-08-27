# Description: 
#   Listens for patterns matching youtrack issues and provides information about 
#   them
#
# Dependencies:
#   url
#
# Configuration:
#   HUBOT_YOUTRACK_HOSTNAME = <host:port>
#   HUBOT_YOUTRACK_USERNAME = <user name>
#   HUBOT_YOUTRACK_PASSWORD = <password>
#   HUBOT_YOUTRACK_URL      = <scheme>://<username>:<password>@<host:port>/<basepath>
#
# Commands:
#   what are my issues? - Show my in progress issues
#   what can I work on? - Show open issues
#   #project-number - responds with a summary of the issue
#
# Author:
#   Dusty Burwell, Jeremy Sellars and Jens Jahnke

URL = require "url"

http = require 'http'
https = require 'https'

yt_url   = process.env.HUBOT_YOUTRACK_URL
host     = process.env.HUBOT_YOUTRACK_HOSTNAME
username = process.env.HUBOT_YOUTRACK_USERNAME
password = process.env.HUBOT_YOUTRACK_PASSWORD

if yt_url?
  url_parts = URL.parse(yt_url)
  scheme = url_parts.protocol
  username = url_parts.auth.split(":")[0]
  password = url_parts.auth.split(":")[1]
  host = url_parts.host
  path = url_parts.pathname if url_parts.pathname?
else
  scheme = 'http://'


# http://en.wikipedia.org/wiki/You_talkin'_to_me%3F
youTalkinToMe = (msg, robot) ->
  input = msg.message.text.toLowerCase()
  name = robot.name.toLowerCase()
  input.indexOf(name) != -1

getProject = (msg) ->
  s = msg.message.room.replace /-.*/, ''

module.exports = (robot) ->

  robot.hear /what (are )?my issues/i, (msg) ->
    msg.send "@#{msg.message.user.name}, you have many issues.  Shall I enumerate them?  I think not."   if Math.random() < .2

  robot.hear /what ((are )?my issues|am I (doing|working on|assigned))/i, (msg) ->
    return unless youTalkinToMe msg, robot
    filter = "for:+#{getUserNameFromMessage(msg)}+state:-Resolved,%20-Completed,%20-Blocked%20,%20-{To%20be%20discussed}"
    askYoutrack "/rest/issue?filter=#{filter}&with=summary&with=state", (err, issues) -> 
      handleIssues err, issues, msg, filter

  robot.hear /what (can|might|should)\s+(I|we)\s+(do|work on)/i, (msg) ->
    return unless youTalkinToMe msg, robot
    filter = "Project%3a%20#{getProject(msg)}%20state:-Resolved,%20-Completed,%20-Blocked%20,%20-{To%20be%20discussed}"
    askYoutrack "/rest/issue?filter=#{filter}&with=summary&with=state&max=100", (err, issues) -> 
      handleIssues err, issues, msg, filter

  hashTagYoutrackIssueNumber = /#([^-]+-[\d]+)/i
  robot.hear hashTagYoutrackIssueNumber, (msg) ->
    issueId = msg.match[1]
    askYoutrack "/rest/issue/#{issueId}", (err, issue) ->
      return msg.send "I'd love to tell you about it, but there was an error looking up that issue" if err?
      if issue.field
        summary = field.value for field in issue.field when field.name == 'summary'
        msg.send "You're talking about #{scheme}#{host}/issue/#{issueId}\r\nsummary: #{summary}"
      else
        msg.send "I'd love to tell you about it, but I couldn't find that issue"

  handleIssues = (err, issues, msg, filter) ->
    msg.send if err?
        'Not to whine, but\r\n' + err.toString()
      else if not issues.issue.length
        "#{msg.message.user.name}, I guess you get to go home because there's nothing to do"
      else
        topIssues = if issues.issue.length <= 5 then issues.issue else issues.issue.slice 0, 5
        resp = "#{msg.message.user.name}, perhaps you will find one of these #{topIssues} #{getProject(msg)} issues to your liking:\r\n"
        issueLines = for issue in topIssues
          summary = issue.field[0].value
          state = issue.field[1].value
          issueId = issue.id
          verb = (if state.toString() == "Open" then "Start" else "Finish")
          "#{verb} \"#{summary}\" (#{scheme}#{host}/issue/#{issueId})"
        resp += issueLines.join ',\r\nor maybe '
        if topIssues.length != issues.issue.length
          url = "#{scheme}#{host}/issues/?q=#{filter}"
          resp+= '\r\n' + "or maybe these #{issues.issue.length}: #{url}"
        resp

  getUserNameFromMessage = (msg) ->
    user = msg.message.user.name
    user = 'me' if user = "Shell"
    user

  askYoutrack = (path, callback) ->
    login (login_res) ->
      cookies = (cookie.split(';')[0] for cookie in login_res.headers['set-cookie'])
      ask_options = {
        host: host,
        path: path,
        headers: {
          Cookie: cookies,
          Accept: 'application/json'
        }
      }
      ask_options.path = path + ask_options.path if path?

      ask_res ->
        data = ''

        ask_res.on 'data', (chunk) ->
          data += chunk

        ask_res.on 'end', () ->
          answer = JSON.parse data
          callback null, answer

        ask_res.on 'error', (err) ->
          callback err ? new Error 'Error getting answer from youtrack'

      if scheme == 'https://'
        ask_req = https.get ask_options, ask_res
      else
        ask_req = http.get ask_options, ask_res

      ask_req.on 'error', (e) ->
        callback e ? new Error 'Error asking youtrack'

  login = (handler) ->
    options = {
      host: host
      path: "/rest/user/login?login=#{username}&password=#{password}",
      method: "POST"
    }
    options.path = path + options.path if path?

    if scheme == 'https://'
      login_req = https.request options, handler
    else
      login_req = http.request options, handler

    login_req.end()
