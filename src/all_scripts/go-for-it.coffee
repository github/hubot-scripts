gophers = [
  'http://25.media.tumblr.com/tumblr_m6k6iluYFU1qa4vxjo1_500.jpg'
  'http://www.sixprizes.com/wp-content/uploads/gopher_caddyshack.jpg'
  'http://i395.photobucket.com/albums/pp33/GalenSwyers/armed_gopher.jpg'
  'http://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Urocitellus_columbianus_Alberta_Martybugs.jpg/220px-Urocitellus_columbianus_Alberta_Martybugs.jpg'
  'http://colourlovers.com.s3.amazonaws.com/blog/wp-content/uploads/2008/09/cg/Gopher-Broke.jpg'
  'http://blogs.citypages.com/gimmenoise/Gophers_Call_Me.jpg'
  'http://www.bakingdom.com/wp-content/uploads/2010/09/caddyshack-gopher.jpg'
]

module.exports = (robot) ->

  # Enable a looser regex if environment variable is set
  if process.env.HUBOT_SHIP_EXTRA_GOPHERS
    regex = /(went|go(ing|es))? for it/i
  else
    regex = /go for it/i

  robot.hear regex, (msg) ->
    msg.send msg.random gophers