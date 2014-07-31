# Description:
#   Display Video from Dailymotion.
#
# Commands:
#   hubot dailymotion me <query> - Searches Dailymotion for the query and returns the video embed link.
#
# Author:
#   Zedenem (https://github.com/zedenem)

module.exports = (robot) ->
  robot.respond /(dailymotion|dm|daily)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    robot.http("https://api.dailymotion.com/videos")
      .query({
        limit: 1
        fields: 'url'
        family_filter: 0
        search: query
      })
      .get() (err, res, body) ->
        videos = JSON.parse(body)
        videos = videos.list

        unless videos?
          msg.send "No video results for \"#{query}\""
          return
          
        msg.send videos[0].url