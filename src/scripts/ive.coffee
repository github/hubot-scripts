# Description:
#   To create something that's… that's genuinely new,
#   you have to… to start again.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <anything Ivey> - Display an Ive
#
# Author:
#   arbales

ives = [
  "http://www.blogcdn.com/www.engadget.com/media/2012/03/jony-ive-10-20-09.jpg",
  "http://betanews.com/wp-content/uploads/media/60/6057.png",
  "http://www.socialgazelle.com/wp-content/uploads/2012/05/jonathan-ive.jpg",
  "http://www3.pcmag.com/media/images/238530-jonathan-ive.jpg",
  "http://farm5.static.flickr.com/4089/5213864251_6a686844ca.jpg",
  "http://www.ipadforums.net/wallpapers/data/500/jonathan_ive.JPG",
  "http://www.wearesuperfamous.com/wp-content/jonny_ive11.jpg"
]

module.exports = (robot) ->
  robot.hear /(aluminium|essential|elegant|efficient|experience|incredible|meticulous|unibody|from the ground up)/i, (msg) ->
    msg.send msg.random ives

