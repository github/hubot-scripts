# abstract <topic> - Prints a nice abstract of the given topic.

# Copyright (c) 2011 John Tantalo
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

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
