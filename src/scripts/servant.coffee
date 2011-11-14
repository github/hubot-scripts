# Hubot is very attentive

module.exports = (robot) ->
  name_regex = new RegExp("#{robot.name}\\?$", "i")

  robot.hear name_regex, (msg) ->
    msg.reply "Yes, master?"
