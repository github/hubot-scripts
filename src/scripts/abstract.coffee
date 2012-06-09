# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot abstract <topic> - Prints a nice abstract of the given topic
#
# Author:
#   tantalor

module.exports = (robot) ->
  robot.respond /(abs|abstract) (.+)/i, (res) ->
    abstract_url = "http://api.duckduckgo.com/?format=json&q=#{encodeURIComponent(res.match[2])}"
    res.http(abstract_url)
      .header('User-Agent', 'Hubot Abstract Script')
      .get() (err, _, body) ->
        return res.send "Sorry, the tubes are broken." if err
        data = JSON.parse(body.toString("utf8"))
        return unless data
        topic = data.RelatedTopics[0] if data.RelatedTopics and data.RelatedTopics.length
        if data.AbstractText
          # hubot abs numerology
          # Numerology is any study of the purported mystical relationship between a count or measurement and life.
          # http://en.wikipedia.org/wiki/Numerology
          res.send data.AbstractText
          res.send data.AbstractURL if data.AbstractURL
        else if topic and not /\/c\//.test(topic.FirstURL)
          # hubot abs astronomy
          # Astronomy is the scientific study of celestial objects.
          # http://duckduckgo.com/Astronomy
          res.send topic.Text
          res.send topic.FirstURL
        else if data.Definition
          # hubot abs contumacious
          # contumacious definition: stubbornly disobedient.
          # http://merriam-webster.com/dictionary/contumacious
          res.send data.Definition
          res.send data.DefinitionURL if data.DefinitionURL
        else
          res.send "I don't know anything about that."
