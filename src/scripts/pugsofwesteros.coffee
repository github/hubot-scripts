# Description:
#   The Pugs of Westeros
#
# Configuration:
#   None
#
# Commands:
#   game of thrones | westeros - Reply with a pug of Westeros
#   ned | stark | winterfell - Reply with Ned or the Starks
#   tyrion | imp - Reply with Tyrion
#   jon snow | you know nothing - Reply with Jon Snow
#   tyrion | imp - Reply with Tyrion
#   king | joffrey | bastard - Reply with The king Bastard Joffrey
#   daenerys | targaryen - Reply with Daenerys

pugs = [
  "http://38.media.tumblr.com/076aebb944f6a19bfa1ae4d82b355fed/tumblr_n7p1mmtIz71r3gb3zo1_400.gif",
  "http://31.media.tumblr.com/741eebca8865bdbc7ac7af23db6adc1d/tumblr_n7p1mmtIz71r3gb3zo2_400.gif",
  "http://37.media.tumblr.com/a0730380fdcc69a0cdbfec82e03ead8e/tumblr_n7p1mmtIz71r3gb3zo3_400.gif",
  "http://38.media.tumblr.com/4504d1a9ee49ca3725ea1f55f2c009ea/tumblr_n7p1mmtIz71r3gb3zo4_400.gif",
  "http://38.media.tumblr.com/0e95c2fd647c640b727e1d0103bf6253/tumblr_n7p1mmtIz71r3gb3zo5_400.gif",
  "http://38.media.tumblr.com/89d68c250a2b79295c1ef1b5e368198f/tumblr_n7p1mmtIz71r3gb3zo6_400.gif",
  "http://37.media.tumblr.com/05f5c40cb0a132868fd7a1a8eaa6e55b/tumblr_n7p1mmtIz71r3gb3zo7_400.gif",
  "http://37.media.tumblr.com/63607822541d0ed463fee5adc5dd68ef/tumblr_n7p1mmtIz71r3gb3zo8_400.gif"
]

ned = [
  "http://31.media.tumblr.com/741eebca8865bdbc7ac7af23db6adc1d/tumblr_n7p1mmtIz71r3gb3zo2_400.gif",
  "http://38.media.tumblr.com/0e95c2fd647c640b727e1d0103bf6253/tumblr_n7p1mmtIz71r3gb3zo5_400.gif"
]

tyrion = [
  "http://38.media.tumblr.com/076aebb944f6a19bfa1ae4d82b355fed/tumblr_n7p1mmtIz71r3gb3zo1_400.gif",
  "http://38.media.tumblr.com/89d68c250a2b79295c1ef1b5e368198f/tumblr_n7p1mmtIz71r3gb3zo6_400.gif"
]

module.exports = (robot) ->
  jonsnow = ->
    "http://37.media.tumblr.com/a0730380fdcc69a0cdbfec82e03ead8e/tumblr_n7p1mmtIz71r3gb3zo3_400.gif"


  king = ->
    "http://37.media.tumblr.com/63607822541d0ed463fee5adc5dd68ef/tumblr_n7p1mmtIz71r3gb3zo8_400.gif"


  daenerys = ->
    "http://38.media.tumblr.com/076aebb944f6a19bfa1ae4d82b355fed/tumblr_n7p1mmtIz71r3gb3zo1_400.gif"



  robot.hear /game of thrones|westeros/i, (msg) ->
    msg.send msg.random pugs

  robot.hear /ned|stark|winterfell/i, (msg) ->
    msg.send msg.random ned

  robot.hear /tyrion|imp/i, (msg) ->
    msg.send msg.random tyrion

  robot.hear /jon snow|you know nothing/i, (msg) ->
    msg.send jonsnow()

  robot.hear /king|joffrey|bastard/i, (msg) ->
    msg.send king()

  robot.hear /daenerys|targaryen/i, (msg) ->
    msg.send daenerys()

  

