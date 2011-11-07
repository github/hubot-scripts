# Hubot will respond to (in)appropriate lines with "That's what she said"
#
# hubot <anything related to size, speed, quality, specific body parts> - Hubot will "that's what she said" that ish

module.exports = (robot) ->
  robot.respond /.*(big|small|long|hard|soft|mouth|face|good|fast|slow|in there|on there|in that|on that|wet|dry|on the|in the|suck|blow|jaw|all in|fit that|fit it|hurts|hot|huge|balls|stuck)/i, (msg) ->
    msg.send "THAT'S WHAT SHE SAID!"