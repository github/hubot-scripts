# Who doesnt love Penny Arcade?
#
# pa - The latest Penny Arcade comic
# pa <date> - Penny Arcade comic from <date> - mm/dd/yyyy format

htmlparser = require "htmlparser"
Select     = require("soupselect").select

module.exports = (robot) ->
  robot.respond /pa\s?((0?[1-9]|1[0-2]).(0?[1-9]|[1-2][0-9]|3[0-1]).(19\d{2}|20\d{2})$)?/i, (msg) ->
    if msg.match[1] == undefined
      date = ''
    else
      date = "#{msg.match[4]}/#{msg.match[2]}/#{msg.match[3]}/"
    
    msg.http("http://penny-arcade.com/comic/#{date}")
        .get() (err, res, body) ->
          handler = new htmlparser.DefaultHandler()
          parser = new htmlparser.Parser(handler)
          parser.parseComplete(body)

          img = Select handler.dom, ".comic img"
          comic = img[0].attribs

          msg.send comic.src
          msg.send comic.alt