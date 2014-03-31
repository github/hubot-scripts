# Description:
#   Display a random gopher
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SHIP_EXTRA_GOPHERS # Optional
#
# Commands:
#   go for it
#   went for it
#   going for it
#   goes for it
#
# Author:
#   dylanegan

gophers = [
  'http://25.media.tumblr.com/tumblr_m6k6iluYFU1qa4vxjo1_500.jpg'
  'http://www.sixprizes.com/wp-content/uploads/gopher_caddyshack.jpg'
  'http://i395.photobucket.com/albums/pp33/GalenSwyers/armed_gopher.jpg'
  'http://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Urocitellus_columbianus_Alberta_Martybugs.jpg/220px-Urocitellus_columbianus_Alberta_Martybugs.jpg'
  'http://colourlovers.com.s3.amazonaws.com/blog/wp-content/uploads/2008/09/cg/Gopher-Broke.jpg'
  'http://blogs.citypages.com/gimmenoise/Gophers_Call_Me.jpg'
  'http://www.bakingdom.com/wp-content/uploads/2010/09/caddyshack-gopher.jpg'
  'http://www.quickmeme.com/img/8e/8eb558b54f0a0522520d05f4c990536b646e63b1d42d8984fbc42ff082a05ee1.jpg'
  'http://www.youtube.com/watch?v=y8Kyi0WNg40'
  'http://weknowmemes.com/generator/uploads/generated/g1381159009196981166.jpg'
  'http://www.quickmeme.com/img/6f/6f8cb22cc6aff2709fc3d760b85b84f6fdbcb4aca0285bd40d8c5a7f74280f9b.jpg'
  'https://i.chzbgr.com/maxW500/1415148288/hF21C98D1/'
  'http://i.huffpost.com/gen/1365387/thumbs/n-BILL-MURRAY-CADDYSHACK-large570.jpg'
  'http://cdn.cutestpaw.com/wp-content/uploads/2012/06/l-Gopher-greeting.jpg'
  'http://www.lawlz.org/wp-content/uploads/2012/07/gopher-tech-support-have-you-tried-chewing-on-the-cable-computer-meme.jpg'
  'http://images.pictureshunt.com/pics/g/gopher_teeth-8191.jpg'
  'http://www.tnt-audio.com/jpeg/gopher.jpg'
  'http://dailypicksandflicks.com/wp-content/uploads/2012/01/stand-back-i-got-this-gopher.jpg'
  'http://funnyasduck.net/wp-content/uploads/2012/12/funny-fat-squirrel-gopher-groundhog-egg-atop-burger-dont-mind-if-do-pics.jpg'
  'http://notalwaysrelated.com/wp-content/uploads/2012/11/3r7hje.jpeg'
  'http://farm3.staticflickr.com/2268/1992861119_88028372b1_o.jpg'
  'http://www.zerotocruising.com/wp-content/uploads/2013/04/groundhog.jpg'
]

module.exports = (robot) ->

  # Enable a looser regex if environment variable is set
  if process.env.HUBOT_SHIP_EXTRA_GOPHERS
    regex = /(went|go(ing|es)?) for it/i
  else
    regex = /go for it/i

  robot.hear regex, (msg) ->
    msg.send msg.random gophers
