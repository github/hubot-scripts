# Description:
#   Returns the latest news headlines from Google
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot news - Get the latest headlines
#   hubot news <topic> - Get the latest headlines for a specific topic
#
# Author:
#   Matt McCormick

module.exports = (robot) ->
  robot.respond /news(?: me| on)?\s?(.*)/, (msg) ->
    query msg, (response, err) ->
      return msg.send err if err

      strings = []
      
      topic = msg.match[1]
      
      if (topic != "")
        strings.push "Here's the latest news on \"#{topic}\":\n"
      else
        strings.push "Here's the latest news headlines:\n"
      
      for story in response.responseData.results
        strings.push story.titleNoFormatting.replace(/&#39;/g, "'").replace(/`/g, "'").replace(/&quot;/g, "\"")
        strings.push story.unescapedUrl + "\n"

      msg.send strings.join "\n"

  query = (msg, cb) ->
    if (msg.match[1] != "")
      msg.http("https://ajax.googleapis.com/ajax/services/search/news?v=1.0&rsz=5")
        .query(q: msg.match[1])
        .get() (err, res, body) ->
          complete cb, body, err
    else
      msg.http("https://ajax.googleapis.com/ajax/services/search/news?v=1.0&rsz=5&topic=h")
        .get() (err, res, body) ->
          complete cb, body, err

  complete = (cb, body, err) ->
    try
      response = JSON.parse body
    catch err
      err = "Sorry, but I could not fetch the latest headlines."
    cb(response, err)
