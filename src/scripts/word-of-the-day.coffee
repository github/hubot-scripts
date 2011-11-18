# Return the word of the day.
#
# You'll need an API key from http://developer.wordnik.com/ or from
# http://developer.dictionary.com/
#
# Set the env variable WOTD_PROVIDER to 'wordnik' or 'dictionary'.
#
# wotd (me) (short) - Returns the word of the day.
# word of the day (me) (short) - Returns the word of the day.
Parser = require("xml2js").Parser

module.exports = (robot) ->

  robot.respond /(word of the day|wotd)\s?(me)?\s?(short)?(.*)$/i, (msg) ->
    if process.env.WOTD_PROVIDER is "wordnik" and process.env.WORDNIK_API_KEY?
      wotd_wordnik msg, msg.match[3]?
    else if process.env.WOTD_PROVIDER is "dictionary" and process.env.DICTIONARY_API_KEY?
      wotd_dictionary msg, msg.match[3]?
    else
      msg.send "Missing WOTD_PROVIDER, WORDNIK_API_KEY or DICTIONARY_API_KEY env variable"

wotd_wordnik = (msg, short_response) ->
  msg.http("http://api.wordnik.com/api/wordoftheday.json")
    .header("api_key", process.env.WORDNIK_API_KEY)
    .get() (err, res, body) ->
      if err?
        lookup_error msg, err
      else
        wotd = JSON.parse(body)
        if wotd.wordstring?
          msg.send "Word of the day: #{wotd.wordstring}"
        if wotd.definition?
          for def in wotd.definition
            msg.send "Definition: #{def.text}"
        if not short_response
          if wotd.example?
            for example in wotd.example
              msg.send "Example: #{example.text}"
          if wotd.note?
            msg.send "Note: #{wotd.note}"

wotd_dictionary = (msg, short_response) ->
  msg.http("http://api-pub.dictionary.com/v001")
    .query(vid: process.env.DICTIONARY_API_KEY, type: "wotd")
    .get() (err, res, body) ->
      if err?
        lookup_error msg, err
      else
        parser = new Parser
        parser.parseString body, (error, doc) ->
          wotd = doc.entry
          msg.send "Word of the day: #{wotd.word}"
          msg.send "Pronunciation: #{wotd.pronunciation}"
          msg.send "Audio: #{wotd.audio["@"].audioUrl}"
          if short_response
            msg.send "Definition: (#{wotd.partofspeech}) #{wotd.shortdefinition}"
          else
            for def in wotd.definitions.definition
              msg.send "Definition: (#{def.partofspeech}) #{def.data}"
            for example in wotd.examples.example
              msg.send "Example: #{example.quote}"
            msg.send "Note: #{wotd.footernotes}"

lookup_error = (msg, err) ->
  console.log err
  msg.reply "Sorry, there was an error looking up the word of the day"

