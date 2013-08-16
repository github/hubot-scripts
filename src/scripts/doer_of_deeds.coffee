# Description:
#   Display a inspirational quote whenever the automated build server or someone mentions failure 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   failed - Responds with a great inspirational quote 
#
# Author:
#   Bellspringsteen

quote = [
  "It is not the critic who counts; not the man who points out how the strong man stumbles, or where the doer of deeds could have done them better. The credit belongs to the man who is actually in the arena, whose face is marred by dust and sweat and blood; who strives valiantly; who errs, who comes short again and again, because there is no effort without error and shortcoming; but who does actually strive to do the deeds; who knows great enthusiasms, the great devotions; who spends himself in a worthy cause; who at the best knows in the end the triumph of high achievement, and who at the worst, if he fails, at least fails while daring greatly, so that his place shall never be with those cold and timid souls who neither know victory nor defeat.",
  
]

module.exports = (robot) ->

  robot.hear /failed/i, (msg) ->
      msg.send quote[0]
