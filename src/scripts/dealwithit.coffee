# Display a "deal with it" gif
#
# deal with it - display a "deal with it" gif
#
#

deal = [
  "http://i.imgur.com/ykDuU.gif",
  "http://i.imgur.com/3PWHn.gif",
  "http://i.imgur.com/sEinL.gif",
  "http://i.imgur.com/zsK7e.gif",
  "http://i.imgur.com/rE2aH.gif",
  "http://i.imgur.com/Wj3Do.gif"
]

deal_with_it = (msg) ->
  msg.send msg.random deal

module.exports = (robot) ->
  robot.hear /deal with it/i, (msg)->
    deal_with_it msg
  
  robot.respond /deal with it/i, (msg)->
    deal_with_it msg