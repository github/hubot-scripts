# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   gob it - Display a GOB
#
# Author:
#   dylanegan

gobs = [
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/chicken-dance-2.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/Gob.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/pants.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/pennies1.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/queen_reveal.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/scotch.gif",
  "http://farm1.static.flickr.com/223/511011836_56ae92ec1a_o.gif",
  "http://cdn.nextround.net/wp-content/uploads/2010/03/gob-bluth-gif-6.gif",
  "http://farm1.static.flickr.com/206/510999823_23796e531c_o.gif",
  "http://farm1.static.flickr.com/209/510999843_8243c5d8c2_o.gif",
  "http://farm1.static.flickr.com/200/511028609_77e4eb3619_o.gif",
  "http://farm1.static.flickr.com/224/511001748_881f933034_o.gif",
  "http://farm1.static.flickr.com/209/511032209_4675bf163e_o.gif",
  "http://farm1.static.flickr.com/212/511032213_65f7cd9f12_o.gif",
  "http://25.media.tumblr.com/tumblr_m4rb3j8o9l1qgoi9lo1_500.gif",
  "http://24.media.tumblr.com/tumblr_m3gd8b0Vm71qbhh43o1_500.gif",
  "http://25.media.tumblr.com/tumblr_m0y41dR5Rg1qf0kb5o1_r1_400.gif",
  "http://25.media.tumblr.com/tumblr_m1pl69N19a1qf0kb5o1_400.gif",
  "http://24.media.tumblr.com/tumblr_lyp0cn0ZVh1r69h01o1_r2_250.gif",
  "http://25.media.tumblr.com/tumblr_lyiyhyMJbt1qgoi9lo1_500.gif",
  "http://24.media.tumblr.com/tumblr_lu9m4mCoVB1qk5u7ao1_400.gif",
  "http://25.media.tumblr.com/tumblr_lpabn5sAXF1qldcnvo1_500.gif",
  "http://25.media.tumblr.com/tumblr_lpbjdhqbyF1qa7lwzo1_500.gif",
  "http://25.media.tumblr.com/tumblr_lmq1fewvEi1qb34nxo1_500.gif",
  "http://media.tumblr.com/tumblr_m5hknk8g841qzblt6.gif",
  "http://25.media.tumblr.com/tumblr_lljt1gEqIs1qerndjo1_400.gif",
  "http://24.media.tumblr.com/tumblr_lka9b7SinV1qhivy6o1_500.gif"
]

module.exports = (robot) ->
  robot.hear /gob it/i, (msg) ->
    msg.send msg.random gobs
