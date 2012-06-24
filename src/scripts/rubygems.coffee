# Description:
#   Find a rubygem from rubygems.org
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot there's a gem for <that> - Returns a link to a gem on rubygems.org
#
# Author:
#   sferik

module.exports = (robot) ->
  robot.respond /there's a gem for (.*)/i, (msg) ->
    search = msg.match[1]
    msg.http('https://rubygems.org/api/v1/search.json')
      .query(query: search)
      .get() (err, res, body) ->
        results = JSON.parse(body)
        gems=[]
        for result in results[0..4]
          gems.push "#{result.name}: https://rubygems.org/gems/#{result.name}"
        if gems.length>0 then msg.send gems.join('\n') else msg.send "Actually, there isn't a gem for that!"
