# Description:
#   An HTTP Listener for notifications on github pushes
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#   "gitio": "1.0.1"
#   "underscore": "1.4.x"
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/gh-commits?room=<room> into your github hooks
#   HUBOT_COMMIT_MAX_FILES  -  Caps the number of files hubot will included in an exclaimation.
#   HUBOT_IRC_ROOMS  -  Fallback for rooms to notify, if <room> not set
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/gh-commits[?room=<room>[&type=<type>]]
#
# Authors:
#   nesQuick
#   jjmason
_   = require('underscore')
url = require('url')
querystring = require('querystring')
gitio = require('gitio')
util = require('util')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end()

    user = {}
    user.room = query.room || process.env.HUBOT_IRC_ROOMS
    user.type = query.type if query.type
    robot.logger.debug "and I'm gonna spam into #{user.room} as #{user.type}!"

    push = JSON.parse req.body.payload

    robot.emit 'github:post', push
    
    commits = _.clone push.commits
    if push.head_commit?
      commits.push push.head_commit
    commits = _.uniq commits, (c) -> c.id
    
    if commits.length > 0
      branch = push.ref.replace(/refs\/heads\/?/, '')
      authors = commits.map (c) -> c.author.name
      
      msg = "Got #{commits.length} new #{pluralize('commit', commits.length)}" +
        " to #{push.repository.name} on branch #{branch}"
      lines = [msg]
      count = 0
      for commit in commits 
        do (commit) ->
          robot.logger.debug "trying gitio on #{commit.url}"
          robot.http('http://git.io/')
               .header('Content-Type', 'application/x-www-form-urlencoded')
               .post("url=#{commit.url}") (err, res, body) ->
                  gitio = res.headers.location
                  robot.logger.debug "gitio resp: #{err},#{res},#{body}, => #{gitio}"
                  {added, removed, modified} = commit
                  lines.push " * #{commit.author.name}: #{commit.message} (#{gitio})"
                  format_files(lines, "     removed: ", removed)
                  format_files(lines, "     added: ", added)
                  format_files(lines, "     modified:", modified)
                  count += 1
                  if count == commits.length
                    robot.send user, lines.join("\n") 
    else
      if push.created
        robot.send user, "#{push.pusher.name} created: #{push.ref}: #{push.base_ref}"
      if push.deleted
        robot.send user, "#{push.pusher.name} deleted: #{push.ref}"

    
# not too smart, but it does what we need
pluralize = (word, num) ->
  word + (if num > 1 then 's' else '')

format_files = (lines, prefix, files) ->
  return lines if files.length == 0
  files.sort()
  max = process.env.HUBOT_COMMIT_MAX_FILES ||= 0
  show = _.take files, max
  hide = _.tail files, max
  if hide.length == 0
    if show.length > 2
      show[show.length - 1] = "and #{show[show.length - 1]}"
      show = show.join(", ")
    else
      show = show.join(" and ")
  else
    show.push "and #{hide.length} more #{pluralize 'file', hide.length}"
    show = show.join(', ')
  lines.push "#{prefix} #{show}"
  lines

