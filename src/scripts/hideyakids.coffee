# Antoine Dodson's greatest hits... errr... only hit 
#
# hide ya kids - Hide `em!
#

module.exports = (robot) ->
  robot.hear /hide ya kids/i, (msg) ->
    msg.send "http://www.youtube.com/watch?v=hMtZfW2z9dw"
