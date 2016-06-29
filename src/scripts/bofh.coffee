# Description:
#   Allows Hubot to quote BOFH -- i guess this is really just unix `fortune` :-)
#   What is BOFH? Read this: http://en.wikipedia.org/wiki/Bastard_Operator_From_Hell
#
# Commands:
#   hubot bofh me - returns a BOFH quote.
#
# Author:
#   adamb0mb
http = require 'http'

module.exports = (robot) ->
  robot.respond /bofh me/i, (msg) ->
    http.get { host: 'pages.cs.wisc.edu', path: '/~ballard/bofh/bofhserver.pl' }, (res) ->
      data = ''
      res.on 'data', (chunk) ->	
        data += chunk.toString()
      res.on 'end', () ->
        msg.send data.match( "The cause.+<font .+>(.*)\n</font>" )[1]