# Dictionary definitions with the Wordnik API. You'll need an API key from http://developer.wordnik.com/
#
# define me <word> - Grabs a dictionary definition of a word.
# pronounce me <word> - Links to a pronunciation of a word.

module.exports = (robot) ->
  # Word definition
  robot.respond /define( me)? (.*)/i, (msg) ->
    word = msg.match[2]
    
    fetch_wordnik_resource(msg, word, 'definitions') (err, res, body) ->
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

          # Track the part of speech
          lastSpeechType = def.partOfSpeech

          # Add the definition
          reply += "  - #{def.text}\n"
        
        msg.send reply

  # Pronunciation
  robot.respond /(pronounce|enunciate)( me)? (.*)/i, (msg) ->
    word = msg.match[3]
    
    fetch_wordnik_resource(msg, word, 'audio') (err, res, body) ->
        pronunciations = JSON.parse(body)
      
        if pronunciations.length == 0
          msg.send "No pronounciation for \"#{word}\" found."
        else
          pronunciation = pronunciations[0]
          msg.send pronunciation.fileUrl

fetch_wordnik_resource = (msg, word, resource, callback) ->
  if process.env.WORDNIK_API_KEY == undefined
    msg.send "Missing WORDNIK_API_KEY env variable."
    return
    
  msg.http("http://api.wordnik.com/v4/word.json/#{escape(word)}/#{escape(resource)}")
    .header('api_key', process.env.WORDNIK_API_KEY)
    .get(callback)