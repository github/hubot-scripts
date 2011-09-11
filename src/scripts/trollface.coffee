# Display a random "trollface" image
#
# hubot problem? - Returns a trollface url
#
#
trolls = [
  "http://dl.dropbox.com/u/3561619/trollface.jpeg"
, "http://dl.dropbox.com/u/3561619/TROLLISSA.png"
, "http://f.cl.ly/items/1R0Y0x0m2T3U3W140N1t/Screen%20shot%202011-01-26%20at%204.19.00%20PM.png"
, "http://dl.dropbox.com/u/3561619/gif/yourealmad.gif"
, "http://27.media.tumblr.com/tumblr_l933pqEz4I1qajca9o1_400.jpg"
, "http://i.imgur.com/Ir34G.jpg"
, "http://28.media.tumblr.com/tumblr_lietg5XKKg1qz732no1_500.jpg"
, "http://f.cl.ly/items/3I0E0z3h2V3s0D1J1F3z/troll.gif"
, "http://27.media.tumblr.com/tumblr_lkzii5ZO3S1qz732no1_500.jpg"
, "http://f.cl.ly/items/1B3o2K0X0K1T3V1L1E3N/youmad.gif"
]

module.exports = (robot) ->
  robot.respond /problem\?/i, (msg) ->
    msg.send msg.random trolls
