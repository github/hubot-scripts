# Description:
#   Find a Drupal module using modulepuppy.heroku.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot there's a module for <that>
#   hubot module me <something> - Returns links to modules or themes on drupal.org
#
# Author:
#   henrrrik

module.exports = (robot) ->
  robot.hear /there's a module for (.*)/i, (msg) ->
    puppySearch msg, msg.match[1]

  robot.respond /module me (.*)/i, (msg) ->
    puppySearch msg, msg.match[1]

puppySearch = (msg, query) -> 
  msg.http('http://modulepuppy.heroku.com/search.json')
    .query(query: query)
    .get() (err, res, body) ->
      results = JSON.parse(body)
      modules=[]
      for result in results[0..30]
        modules.push "#{result.project.title}: #{result.project.link}"
      if modules.length>0 then msg.send modules.join('\n') else msg.send "Actually, there isn't a module for that!"
