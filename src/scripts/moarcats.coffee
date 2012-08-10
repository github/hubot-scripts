# moarcats
# random cat gifs as a service for your cat gif driven development

module.exports = (robot) ->
  robot.respond /moarcat/i, (msg) ->
    msg.send "http://lo.no.de"
