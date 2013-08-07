# Description
#   Tells Hubot to search for anything in code at GitHub
#
# Dependencies:
#   "githubot": "0.4.1"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN (optional, if you want to search in private repos)
#
# Commands:
#   hubot github search [repo] <query> - Search for <query> in [repo] or anywhere
#
# Author:
#   spajus

module.exports = (robot) ->

  github = require('githubot')(robot, apiVersion: 'preview')

  robot.respond /github search ((.+\/[^\s]+) )?(.+)/i, (msg) ->
    try
      repo = msg.match[2]
      query = msg.match[3].trim()
      repostr = ''
      in_repo = ''

      if repo
        repostr = "+repo:#{repo}"
        in_repo = " in repo #{repo}"

      github.handleErrors (response) ->
        msg.send "Error: #{response.statusCode} #{response.error}"

      github.get "search/code?q=#{encodeURIComponent(query)}#{repostr}&sort=indexed", (data) ->
        resp = ''
        found = 0

        if data.total_count == 0
          msg.send "Didn't find \"#{query}\"#{in_repo}"
          return

        for item in data.items
          if found == 5
            broken = true
            break
          resp += "\n - #{item.name}: #{item.html_url}"
          found += 1

        first_n = ''
        if broken
          first_n = ", first 5"
          resp += "\nMore: https://github.com/search?q=#{encodeURIComponent(query)}#{repostr}&type=Code&s=indexed"

        msg.send "Searched for \"#{query}\"#{in_repo} and found #{data.total_count} results#{first_n}: #{resp}"
    catch e
      console.log "GitHub Search failed", e
