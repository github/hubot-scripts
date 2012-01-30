# Find a Drupal module using modulepuppy.heroku.com
#
# <there's a module for> that
# or
# <module me> something - Returns links to modules or themes on drupal.org

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

