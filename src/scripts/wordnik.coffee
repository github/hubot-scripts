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

  robot.respond /spell(?: me)? (.*)/i, (msg) ->
    if not process.env.WORDNIK_API_KEY?
      msg.send "Missing WORDNIK_API_KEY env variable."
      return

    word = msg.match[1]

    msg.http("http://api.wordnik.com/v4/word.json/#{escape(word)}?includeSuggestions=true")
      .header('api_key', process.env.WORDNIK_API_KEY)
      .get() (err, res, body) ->
        wordinfo = JSON.parse(body)
        if wordinfo.canonicalForm
          msg.send "\"#{word}\" is a word."
        else if not wordinfo.suggestions
          console.log wordinfo.suggestions
          msg.send "No suggestions for \"#{word}\" found."
        else
          list = wordinfo.suggestions.join(', ')
          msg.send "Suggestions for \"#{word}\": #{list}"
