# look of disapproval (optional: name)

module.exports = (robot) ->
  robot.respond /lod\s?(.*)/i, (msg) ->
    response = 'ಠ_ಠ'

    name = msg.match[1].trim()
    response += " @" + name if name != ""

    msg.send(response)

