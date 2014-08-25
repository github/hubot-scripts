# Description:
#   Dictionary definitions with the Wordnik API. 
#
# Dependencies:
#   None
#
# Configuration:
#   WORDNIK_API_KEY
#
# Commands:
#   hubot define me <word> - Grabs a dictionary definition of a word.
#   hubot pronounce me <word> - Links to a pronunciation of a word.
#   hubot spell me <word> - Suggests correct spellings of a possible word.
#   hubot wotd me (short) - Returns the word of the day.
#   hubot word of the day me (short) - Returns the word of the day.
#
# Notes:
#   You'll need an API key from http://developer.wordnik.com/
#   FIXED Merged with word-of-the-day.coffee (however, only uses wordnik)
#
# Author:
#   Aupajo
#   markpasc

module.exports = (robot) ->
  # Word definition
  robot.respond /define( me)? (.*)/i, (msg) ->
    word = msg.match[2]
    
    fetch_wordnik_resource(msg, word, 'definitions', {}) (err, res, body) ->
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
    
    fetch_wordnik_resource(msg, word, 'audio', {}) (err, res, body) ->
        pronunciations = JSON.parse(body)
      
        if pronunciations.length == 0
          msg.send "No pronounciation for \"#{word}\" found."
        else
          pronunciation = pronunciations[0]
          msg.send pronunciation.fileUrl

  robot.respond /spell(?: me)? (.*)/i, (msg) ->
    word = msg.match[1]

    fetch_wordnik_resource(msg, word, '', {includeSuggestions: 'true'}) (err, res, body) ->
      wordinfo = JSON.parse(body)
      if wordinfo.canonicalForm
        msg.send "\"#{word}\" is a word."
      else if not wordinfo.suggestions
        msg.send "No suggestions for \"#{word}\" found."
      else
        list = wordinfo.suggestions.join(', ')
        msg.send "Suggestions for \"#{word}\": #{list}"

  robot.respond /(word of the day|wotd)\s?(me)?\s?(short)?(.*)$/i, (msg) ->
    if process.env.WORDNIK_API_KEY?
      fetch_wordnik_wotd msg, msg.match[3]?
    else
      msg.send "Missing WORDNIK_API_KEY env variable."

fetch_wordnik_resource = (msg, word, resource, query, callback) ->
  # FIXME prefix with HUBOT_ for
  if process.env.WORDNIK_API_KEY == undefined
    msg.send "Missing WORDNIK_API_KEY env variable."
    return
    
  msg.http("http://api.wordnik.com/v4/word.json/#{escape(word)}/#{escape(resource)}")
    .query(query)
    .header('api_key', process.env.WORDNIK_API_KEY)
    .get(callback)

fetch_wordnik_wotd = (msg, short_response) ->
  msg.http("http://api.wordnik.com/v4/words.json/wordOfTheDay")
    .header("api_key", process.env.WORDNIK_API_KEY)
    .get() (err, res, body) ->
      if err?
        msg.reply "Sorry, there was an error looking up the word of the day"
      else
        wotd = JSON.parse(body)
        if not wotd.word?
          msg.reply "Sorry, there was no word of the day"
          return;

        reply = "Word of the day: #{wotd.word}\n"        
        lastSpeechType = null

        if wotd.definitions?
          reply += "Definitions:\n"
          for def in wotd.definitions
            if def.partOfSpeech != lastSpeechType
              reply += " (#{def.partOfSpeech})\n" if def.partOfSpeech != undefined

            # Track the part of speech
            lastSpeechType = def.partOfSpeech

            # Add the definition
            reply += "  - #{def.text}\n"
        else
          reply += "No definitions for #{wotd.word}"
        if not short_response
          if wotd.examples?
            reply += "\nExamples:\n"
            for example in wotd.examples
              reply += "  - #{example.text}\n"
          if wotd.note?
            reply += "\nNote:\n"
            reply += "  - #{wotd.note}"
        msg.send reply
