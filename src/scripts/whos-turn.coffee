# Who's turn to do something ?
#
# who <does something> : <someone>, <someone>, <someone> ? - Returns who does !
#                      
module.exports = (robot) ->
  robot.respond /(who|qui) (.+) : (.+) \?/i, (msg) ->
    action = msg.match[2]
    member = msg.random msg.match[3].split /[\s]*,[\s]*/
    msg.send member + " " + action + " !"

