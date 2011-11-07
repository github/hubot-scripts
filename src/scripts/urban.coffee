# Searches Urbandictionary
#
# urban <word> Searches Urbandictionary

module.exports = (robot) ->
  robot.respond /urban( me)? (.*)$/i, (msg) ->
   word = msg.match[2]
   console.log word
   msg.http("http://www.urbandictionary.com/iphone/search/define?term=#{escape(word)}")
    .get() (err, res, body) ->
      response = JSON.parse body
      result = response.list
      if response.result_type is ("exact" or "fulltext")
        msg.send (word.definition) for word in result
      else
        i = 0
        while i < result.length
          word = result[i]
          message = "Not found. Maybe you mean " + result[i-1].term + " or " + result[i+1].term + "?"  if word.type is "undefined"
          i++
	      msg.send message