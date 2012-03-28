# Hubot enjoys delicious snacks
#
# botsnack - give the boot a food

module.exports = (robot) ->
  robot.hear /^botsnack/i, (msg) ->
    msg.send ":D"
