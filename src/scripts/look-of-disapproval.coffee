# Allows Hubot to give a look of disapproval. 
#
# lod <name> - gives back the character for the look of disapproval, optionally @name.

module.exports = (robot) ->
  robot.respond /lod\s?(.*)/i, (msg) ->
    response = 'ಠ_ಠ'

    name = msg.match[1].trim()
    response += " @" + name if name != ""

    msg.send(response)

