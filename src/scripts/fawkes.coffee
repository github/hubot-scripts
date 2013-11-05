# Description:
#   Celebrate Guy Fawkes Day with Hubot
#   Hubot will recite http://www.potw.org/archive/potw405.html
#   Whenever it hears any of the words in "Commands"
#   Only on November 5!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   "remember", "fawkes", "gunpowder", "plot",
#   "bonfire", "firework", "vendetta"
#
# Author:
#   thalweg

remember = "Remember, remember!\n
    The fifth of November,\n
    The Gunpowder treason and plot;\n
    I know of no reason\n
    Why the Gunpowder treason\n
    Should ever be forgot!\n
    Guy Fawkes and his companions\n
    Did the scheme contrive,\n
    To blow the King and Parliament\n
    All up alive.\n
    Threescore barrels, laid below,\n
    To prove old England's overthrow.\n
    But, by God's providence, him they catch,\n
    With a dark lantern, lighting a match!\n
    A stick and a stake\n
    For King James's sake!\n
    If you won't give me one,\n
    I'll take two,\n
    The better for me,\n
    And the worse for you.\n
    A rope, a rope, to hang the Pope,\n
    A penn'orth of cheese to choke him,\n
    A pint of beer to wash it down,\n
    And a jolly good fire to burn him.\n
    Holloa, boys! holloa, boys! make the bells ring!\n
    Holloa, boys! holloa boys! God save the King!\n
    Hip, hip, hooor-r-r-ray!"

now = new Date
if now.getMonth() == 10 and now.getDate() == 5
  module.exports = (robot) ->

    words = ["remember", "fawkes", "gunpowder", "plot", "bonfire", "firework", "vendetta"]
    regex = new RegExp('(?:^|\\s)(' + words.join('|') + ')(?:\\s|\\.|\\?|!|$)', 'i');

    robot.hear regex, (msg) ->
      msg.send remember
