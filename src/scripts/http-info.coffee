# Description:
#   Returns title and description when links are posted
#
# Dependencies:
#   "jsdom": "0.8.10"
#   "underscore": "1.3.3"
#
# Configuration:
#   HUBOT_HTTP_INFO_IGNORE_URLS - RegEx used to exclude Urls
#   HUBOT_HTTP_INFO_IGNORE_USERS - Comma-separated list of users to ignore
#   HUBOT_HTTP_INFO_IGNORE_DESC - Optional boolean indicating whether a site's meta description should be ignored
#
# Commands:
#   http(s)://<site> - prints the title and meta description for sites linked.
#
# Author:
#   ajacksified

jsdom = require 'jsdom'
_     = require 'underscore'

module.exports = (robot) ->

  ignoredusers = []
  if process.env.HUBOT_HTTP_INFO_IGNORE_USERS?
    ignoredusers = process.env.HUBOT_HTTP_INFO_IGNORE_USERS.split(',')

  robot.hear /(http(?:s?):\/\/(\S*))/i, (msg) ->
    url = msg.match[1]

    username = msg.message.user.name
    if _.some(ignoredusers, (user) -> user == username)
      console.log 'ignoring user due to blacklist:', username
      return

    # filter out some common files from trying
    ignore = url.match(/\.(png|jpg|jpeg|gif|txt|zip|tar\.bz|js|css)/)

    ignorePattern = process.env.HUBOT_HTTP_INFO_IGNORE_URLS
    if !ignore && ignorePattern
      ignore = url.match(ignorePattern)

    jquery = 'http://code.jquery.com/jquery-1.9.1.min.js'

    done = (errors, window) ->
      unless errors
        $ = window.$
        title = $('head title').text().replace(/(\r\n|\n|\r)/gm,'').replace(/\s{2,}/g,' ').trim()
        description = $('head meta[name=description]')?.attr('content')?.replace(/(\r\n|\n|\r)/gm,'')?.replace(/\s{2,}/g,' ')?.trim() || ''

        if title and description and not process.env.HUBOT_HTTP_INFO_IGNORE_DESC
          msg.send "#{title}\n#{description}"

        else if title
          msg.send "#{title}"

    versionCompare = (v1, v2, comparison) ->
      v1parts = v1.split('.')
      v2parts = v2.split('.')

      for value1, i in v1parts
        value1 = parseInt(value1, 10)
        value2 = parseInt(v2parts[i], 10)
        if comparison == '<' and value1 < value2
          return 1
        if comparison == '>' and value1 > value2
          return 1
      return 0

    unless ignore
      if versionCompare jsdom.version, '0.7.0', '<'
        jsdom.env
          html: url
          scripts: [ jquery ]
          done: done
      else
        jsdom.env
          url: url
          scripts: [ jquery ]
          done: done
