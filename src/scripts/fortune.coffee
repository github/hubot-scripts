# Get a fortune
#
# fortune me - Displays a super true fortune

module.exports = (robot) ->
  robot.respond /(fortune)( me)?/i, (msg) ->
    msg.http('http://www.fortunefortoday.com/getfortuneonly.php')
       .get() (err, res, body) ->
         msg.reply body
