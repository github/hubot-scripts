# Description:
#   Make hubot fetch quotes pertaining to the world's best secret agent, Archer.
#
# Dependencies:
#   "scraper": "0.0.9"
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   rrix

scraper = require 'scraper'

module.exports = (robot) ->

  robot.hear /^loggin/i, (msg) ->
    msg.reply "call Kenny Loggins, 'cuz you're in the DANGER ZONE."

  robot.hear /^sitting down/i, (msg) ->
    msg.reply "What?! At the table? Look, he thinks he's people!"

  robot.hear /archer/i, (msg) ->

    options = {
       'uri': 'http://en.wikiquote.org/wiki/Archer_(TV_series)',
       'headers': {
         'User-Agent': 'User-Agent: Archerbot for Hubot (+https://github.com/github/hubot-scripts)'
       }
    }

    scraper options, (err, jQuery) ->
      throw err  if err
      quotes = jQuery("dl").toArray()
      dialog = ''
      quote = quotes[Math.floor(Math.random()*quotes.length)]
      dialog += jQuery(quote).text().trim() + "\n"
      msg.send dialog

  # Make it possible to turn off a few of the more NSFW ones
  unless process.env.HUBOT_ARCHER_SFW

    robot.hear /^benoit/i, (msg) ->
      msg.send "balls"

    robot.hear /love/i, (msg) ->
      msg.reply "And I love that I have an erection... that doesn't involve homeless people."

