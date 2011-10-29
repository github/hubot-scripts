# Dictionary definitions with the Wordnik API. You'll need an API key from http://developer.wordnik.com/
#
# define me <word> - Grabs a dictionary definition of a word.
module.exports = (robot) ->
  robot.respond /define( me)? (.*)/i, (msg) ->
    
    if process.env.WORDNIK_API_KEY == undefined
      msg.send "Missing WORDNIK_API_KEY env variable."
      return
    
    word = msg.match[2]
    
    msg.http("http://api.wordnik.com/v4/word.json/#{escape(word)}/definitions")
      .header('api_key', process.env.WORDNIK_API_KEY)
      .get() (err, res, body) ->
        definitions = JSON.parse(body)
      
        if definitions.length == 0
          msg.send "No definitions for \"#{word}\" found."
        else
          reply = "Definitions for \"#{word}\":\n"
          
          lastSpeechType = null
          definitions = definitions.forEach (def) ->
            # Show the part of speech (noun, verb, etc.) when it changes
            if def.partOfSpeech != lastSpeechType
              reply += " (#{def.partOfSpeech})\n" if def.partOfSpeech != undefined
            
            lastSpeechType = def.partOfSpeech
            
            reply += "  - #{def.text}\n"
          
          msg.send reply

