# Description:
#   Allows Hubot to pull down images from calmingmanatee.com
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot manatee - outputs a random manatee
#
# Author:
#   Danny Lockard

Select = require( "soupselect" ).select
HTMLParser = require "htmlparser"

module.exports = (robot) ->
        robot.respond /manatee/i, (msg) ->
                options = {
                        "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6"
                }
                msg
                        .http( 'http://calmingmanatee.com' )
                        .header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6')
                        .get(options) (err, res, body) ->
                                if err
                                        msg.send "Something went wrong #{err}"
                                        return
                                msg.send "http://calmingmanatee.com/" + get_manatee(body, "body div#holder img")

get_manatee = (body, selector)->
        html_handler = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true)
        html_parser = new HTMLParser.Parser html_handler

        html_parser.parseComplete body
        Select(html_handler.dom, selector)[0].attribs.src
