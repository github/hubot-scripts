# Bees are insane
#
# bees - Oprah at her finest, or a good way to turn the fans on coworkers machines

module.exports = (robot) ->
  robot.respond /bees/i, (message) ->
    message.send "http://thechive.files.wordpress.com/2010/11/oprah-bees.gif"
