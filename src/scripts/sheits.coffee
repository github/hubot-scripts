# Description:
#   When you get some bad news sometimes you got to let it out.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   sheeeit - Display an image or animated gif
#
# Author:
#   danishkhan

sheits = [
  "http://www.gifsoup.com/webroot/animatedgifs1/2019075_o.gif",
  "http://i417.photobucket.com/albums/pp258/reddreadrevolver/sheeeit.gif",
  "http://24.media.tumblr.com/tumblr_lrhm9lVLLi1qfq1lso1_500.jpg"
]

module.exports = (robot) ->
  robot.hear /sh(e+)(i+)(t+)/, (msg) ->
    msg.send msg.random sheits

