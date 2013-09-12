# Description:
#   Let's you know what the fox says!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what does the fox say

module.exports = (robot) ->

  robot.respond /what does the fox say/i, (msg) ->
    msg.send ":dog: goes woof"
    msg.send ":cat2: goes meow"
    msg.send ":bird: goes tweet"
    msg.send "and the :mouse2: goes squeek"
    msg.send ":cow: goes moo"
    msg.send ":frog: goes croak"
    msg.send "and the :elephant: goes toot"
    msg.send ":baby_chick: says quack"
    msg.send "and :fish: goes blub"
    msg.send "and the :dolphin: goes ow ow ow"
    msg.send "But there's one sound"
    msg.send "That no one knows..."
    msg.send "What does the :wolf: say!?"