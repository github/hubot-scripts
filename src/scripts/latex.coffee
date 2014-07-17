# Description:
# Convert LaTeX text into an image
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot latex text - The image for this text
#
# Author:
# Endle

module.exports = (robot) ->
  robot.respond /latex\s+(.*)/i, (msg) ->
    tex = "#{msg.match[1]}"
    link = "http://latex.codecogs.com/gif.latex?#{tex}"

    msg.send "#{link}"

