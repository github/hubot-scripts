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
            ,":cat2: goes meow"
            ,":bird: goes tweet"
            ,"and the :mouse2: goes squeek"
            ,":cow: goes moo"
            ,":frog: goes croak"
            ,"and the :elephant: goes toot"
            ,":baby_chick: says quack"
            ,"and :fish: goes blub"
            ,"and the :dolphin: goes ow ow ow"
            ,"But there's one sound"
            ,"That no one knows..."
            ,"What does the :wolf: say!?"