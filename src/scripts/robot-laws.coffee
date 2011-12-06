# Display the three laws of robotics
#
# http://en.wikipedia.org/wiki/Three_Laws_of_Robotics
#
# law me - Displays the three laws of robotics

laws = [
  "1. A robot may not injure a human being or, through inaction, allow a human being to come to harm."
, "2. A robot must obey the orders given to it by human beings, except where such orders would conflict with the First Law."
, "3. A robot must protect its own existence as long as such protection does not conflict with the First or Second Laws."
]
module.exports = (robot) ->
  robot.respond /law me/i, (msg) ->
    msg.send law for law in laws
