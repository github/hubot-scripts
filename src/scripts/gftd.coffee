# GFTD
#
# why are you still here?
#

module.exports = (robot) ->
  robot.hear /gftd/i, (msg) ->
   currentTime = new Date()
   fivePM = new Date()
   fivePM.setHours(17,0,0)
   difference = fivePM.getTime() - currentTime.getTime()
   hoursDifference = Math.round((difference/1000/60/60)*10)/10
   if hoursDifference > 0
    msg.send "You have " + hoursDifference + " hours to go!"
   else
    msg.send "You should have left " + -(hoursDifference) + " hours ago!"