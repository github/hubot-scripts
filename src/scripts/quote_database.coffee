# Description:
#   A script for creating and recalling quotes from the chat using regular expressions and ID numbers
#
#   Example:
#     hubot addquote Look at me! I'm on TV
#     hubot addquote johnwyles: I really enjoy the band TV on the radio
#     hubot quote *TV*
#       => Look at me! I'm on TV! [ID: 23]
#       => johnwyles: I really enjoy the band TV on the radio [ID: 24]
#     hubot rmquote 23
#       => Do you really want to purge the quote [ID: 23] from the database?  Type 'rmquote 23 seriously' if you are sure!
#     hubot rmquote 23 seriously
#       => The quote has been removed from the database [ID: 23].
#     hubot quote *TV*
#       => johnwyles: I really enjoy the band TV on the radio [ID: 24]
#     hubot quote
#       => Hello World!  This is a random quote from the database! [ID: 832]
#     hubot quote 832
#       => Hello World!  This is a random quote from the database! [ID: 832]
#     hubot quote (F|f)oobar
#       => Foobar [ID: 56]
#       => foobar [ID: 57]
#       => Foobar is barfoo [ID: 58]
#       => There were [2] more quotes found.  To retrieve all of these run again with quoteall.  For example: 'quoteall (F|f)oobar'.
#     hubot quoteall (F|f)oobar
#       => Foobar [ID: 56]
#       => foobar [ID: 57]
#       => Foobar is barfoo [ID: 58]
#       => I once ate a foobar [ID: 61]
#       => Foobar FTW! [ID: 62]
#     hubot purgeallquotes
#       => Do you really want to purge all of the quotes in the database?  Type 'purgeallquotes seriously' if you are sure!
#     hubot purgeallquotes seriously
#       => All quotes have been purged from the database.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot addquote <phrase or body of text>
#   hubot rmquote <quote ID> [seriously]
#   hubot quote [<quote ID OR partial text OR regular expression>]
#   hubot quoteall <partial text OR regular expression>
#   hubot purgeallquotes [seriously]
#
# Author:
#   johnwyles (although some of this is based on NNA's talkative.coffee)

module.exports = (robot) ->

  # The maximum number of quotes output for a search
  maximum_quotes_output = 3

  # This first quote is made mostly unique so it doesn't interfere with the users DB
  # The reason this isn't a simple array and is instead an associative array is because
  # we want to preserve a quotes unique id
  default_quote_database = {
    "next_id": 1,
    "quotes": [
      {"id": 0, "quote": "Th1s1sy0urf1rstqu0te1nth3d4t4b4s3"}
    ],
    "rmquote": [],
    "purgeallquotes": false
  }

  robot.brain.on 'loaded', =>
    robot.brain.data.quote_database = default_quote_database if robot.brain.data.quote_database is undefined

  robot.respond /addquote\s?(.*)?$/i, (msg) ->
    if msg.match[1]
      for quote_index in robot.brain.data.quote_database.quotes
        if quote_index.quote == msg.match[1]
          msg.send "This quote already exists [ID: #{quote_index.id}]."
          return
      quote_id = robot.brain.data.quote_database.next_id++
      robot.brain.data.quote_database.quotes.push {"id": quote_id, "quote": msg.match[1]}
      msg.send "This message has been added [ID: #{quote_id}]."
    else
      msg.send "You must supply some text after 'addquote'.  For example: 'addquote This will be added to the DB.'."

  robot.respond /rmquote\s?(\d+)?( seriously)?$/i, (msg) ->
    if msg.match[1]
      if not robot.brain.data.quote_database.rmquote[msg.match[1]] or not msg.match[2]
        msg.send "Do you really want to purge the quote [ID: #{msg.match[1]}] from the database?  Type 'rmquote #{msg.match[1]} seriously' if you are sure!"
        robot.brain.data.quote_database.rmquote[msg.match[1]] = true
        return

      if robot.brain.data.quote_database.rmquote[msg.match[1]] and msg.match[2]
        for quote_index in robot.brain.data.quote_database.quotes
          if quote_index.id is parseInt(msg.match[1])
            robot.brain.data.quote_database.quotes.splice robot.brain.data.quote_database.quotes.indexOf(quote_index), 1
            msg.send "The quote has been removed from the database [ID: #{quote_index.id}]."
            robot.brain.data.quote_database.rmquote[msg.match[1]] = false
            return
        msg.send "The quote specified could not be found [ID: #{msg.match[1]}]."
    else
      msg.send "You must supply a ID number after 'rmquote'.  For example: 'rmquote 123'."

  robot.respond /quote\s?(?: (\d+)|\s(.*))?$/i, (msg) ->
    quote_database = robot.brain.data.quote_database

    # Find a random quote
    if not msg.match[1] and not msg.match[2]
      random_quote_index = Math.floor(Math.random() * quote_database.quotes.length)
      random_quote = quote_database.quotes[random_quote_index]
      msg.send "#{random_quote.quote} [ID: #{random_quote.id}]"
      return

    # Find quote by ID
    else if msg.match[1]
      for quote_index in robot.brain.data.quote_database.quotes
        if quote_index.id is parseInt(msg.match[1])
          msg.send "#{quote_index.quote} [ID: #{quote_index.id}]"
          return
      msg.send "The quote specified could not be found [ID: #{msg.match[1]}]."

    # Find quote by pattern
    else if msg.match[2]
      quote_found_count = 0
      for quote_index in robot.brain.data.quote_database.quotes
        if quote_index.quote.match new RegExp(msg.match[2])
          quote_found_count++
          if quote_found_count <= maximum_quotes_output
            msg.send "#{quote_index.quote} [ID: #{quote_index.id}]"

        # robot.logging.info "Found: " + quote_found_count + " Max: " + maximum_quotes_output
      if quote_found_count > maximum_quotes_output
        excess_quote_count = quote_found_count - maximum_quotes_output
        msg.send "There were [#{excess_quote_count}] more quotes found.  To retrieve all of these run again with quoteall.  For example: 'quoteall (F|f)oobar'."
        return

      else if quote_found_count < 1
        msg.send "There were no matching quotes found [Pattern: #{msg.match[2]}]."

  robot.respond /quoteall\s?(.*)?$/i, (msg) ->
    # Find all quotes by a pattern
    if msg.match[1]
      quote_found = false
      for quote_index in robot.brain.data.quote_database.quotes
        if quote_index.quote.match new RegExp(msg.match[1])
          quote_found = true
          msg.send "#{quote_index.quote} [ID: #{quote_index.id}]"

      if not quote_found
        msg.send "There were no matching quotes found [Pattern: #{msg.match[1]}]."

    else
      msg.send "You must supply a pattern to match after 'quoteall'.  For example: 'quoteall (F|f)oobar'."


  robot.respond /purgeallquotes\s?( seriously)?$/i, (msg) ->
    if not robot.brain.data.quote_database["purgeallquotes"] or not msg.match[1]
      msg.send "Do you really want to purge all of the quotes in the database?  Type 'purgeallquotes seriously' if you are sure!"
      robot.brain.data.quote_database["purgeallquotes"] = true
      return

    if msg.match[1] and robot.brain.data.quote_database["purgeallquotes"]
      robot.brain.data.quote_database = default_quote_database
      msg.send "All quotes have been purged from the database."
