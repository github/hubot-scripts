#boro is the finest Japanese fabric

boro = [
  "http://stadiumsandshrines.com/wordpress/wp-content/uploads/2012/08/tos_boro_close.jpg",
  "https://www.kimonoboy.com/textiles/images/boro-965-1.jpg",
  "https://www.kimonoboy.com/textiles/images2/boro-2026-5.jpg",
  "https://s-media-cache-ak0.pinimg.com/236x/1c/4e/b6/1c4eb6614e663caba782d2a08a5a6ea8.jpg"
]

module.exports = (robot) ->
  robot.hear /boro bomb/i, (msg) ->
   msg.send msg.random boro
