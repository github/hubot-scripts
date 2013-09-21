# Description:
#   Applause from Orson Welles and others
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   applause|applaud|bravo|slow clap - Get applause
#   sarcastic applause|clap - Get sarcastic applause
#
# Author:
#   joshfrench


images =
  sincere: [
    "http://i.imgur.com/pfrtv6H.gif",
    "http://i.imgur.com/Bp4P8l3.gif",
    "http://i.imgur.com/v7mZ22P.gif",
    "http://i.imgur.com/S1v4KuY.gif",
    "http://i.imgur.com/YTaSAkq.gif",
    "http://i.imgur.com/JO6Wz3r.gif",
    "http://i.imgur.com/pWEd6cF.gif",
    "http://i.imgur.com/zumSlIA.gif",
    "http://i.imgur.com/RGczKmV.gif",
    "http://i.imgur.com/KAQhoCm.gif",
    "http://i.imgur.com/PASRKXo.gif",
    "http://i.imgur.com/ZOWQTO6.gif",
    "http://i.imgur.com/cY0eH5c.gif",
    "http://i.imgur.com/wf5qvOM.gif",
    "http://i.imgur.com/9Zv4V.gif",
    "http://i.imgur.com/t8zvc.gif",
    "http://cache.blippitt.com/wp-content/uploads/2012/06/Daily-Life-GIFs-06-The-Rock-Clapping.gif",
    "http://25.media.tumblr.com/tumblr_m00e9mCyWj1rqtbn0o1_500.gif"
    "http://assets0.ordienetworks.com/images/GifGuide/clapping/Kurtclapping.gif",
    "http://assets0.ordienetworks.com/images/GifGuide/clapping/riker.gif",
    "http://assets0.ordienetworks.com/images/GifGuide/clapping/hp3.gif",
    "http://assets0.ordienetworks.com/images/GifGuide/clapping/1292223254212-dumpfm-mario-Obamaclap.gif",
    "http://www.reactiongifs.com/wp-content/uploads/2013/01/applause.gif"
  ]
  insincere: [
    "http://i.imgur.com/2QXgcqP.gif",
    "http://i.imgur.com/Yih2Lcg.gif",
    "http://i.imgur.com/un3MuET.gif",
    "http://i.imgur.com/H2wPc1d.gif",
    "http://i.imgur.com/uOtALBE.gif",
    "http://i.imgur.com/nmqrdiF.gif",
    "http://i.imgur.com/GgxOUGt.gif",
    "http://i.imgur.com/wyTQMD6.gif",
    "http://i.imgur.com/GYRGOy6.gif",
    "http://i.imgur.com/ojIsLUA.gif",
    "http://i.imgur.com/bRetADl.gif",
    "http://i.imgur.com/814mkEC.gif",
    "http://i.imgur.com/uYryMyr.gif",
    "http://i.imgur.com/YfrikPR.gif",
    "http://i.imgur.com/sBEFqYR.gif",
    "http://i.imgur.com/Sx8iAS8.gif",
    "http://i.imgur.com/5zKXz.gif"
  ]

module.exports = (robot) ->
  robot.hear /applau(d|se)|bravo|sarcastic applause|(slow|sarcastic) clap/i, (msg) ->
    type = if (/sarcastic/i).test(msg.message.text) then images.insincere else images.sincere
    msg.send msg.random type
