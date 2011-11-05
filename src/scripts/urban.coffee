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
      console.log response.list
      msg.send response.list[0].definition