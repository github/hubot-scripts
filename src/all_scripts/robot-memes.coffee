# Description:
#   Robot Memes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot robot - mention the word robot to hubot and he responds with a robot-oriented meme
#
# Author:
#   jrob00

robot_memes = [
	"http://troll.me/images/ancient-aliens-guy/but-you-see-steve-is-a-alien-robot-thumb.jpg",
	"http://troll.me/images/arnold-disgusting/i-see-robots-thumb.jpg",
	"http://troll.me/images/bender/i-am-not-a-robot-i-am-a-unicorn-thumb.jpg",
	"http://troll.me/images/bender/i-be-no-human-i-be-robot-with-emotion-thumb.jpg",
	"http://troll.me/images/bender/robots-cant-pimp-sure-thumb.jpg",
	"http://troll.me/images/compliment-bender/indeed-my-robotic-friend-bite-my-lustrous-metallic-behind-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/can-bust-the-robot-dance-so-well-what-if-im-a-robot-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/cant-read-the-captcha-verification-what-if-i-am-a-robot-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/he-busts-the-robot-dance-so-well-what-if-hes-a-robot-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-dubstep-is-just-robots-singing-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-everyone-is-a-robot-except-me-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-im-the-only-human-and-everyone-else-are-just-robots-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-like-everyone-i-know-is-a-robot-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-this-is-an-alternate-universe-created-for-us-by-robots-thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-we-are-robots-programmed-to-think-we-are-humans--thumb.jpg",
	"http://troll.me/images/conspiracy-keanu/what-if-were-scary-to-the-robots-thumb.jpg",
	"http://troll.me/images/futurama-fry/could-be-a-man-in-robotsuit-or-could-it-be-robot-in-mansuit-in-a-robotsuit-thumb.jpg",
	"http://troll.me/images/futurama-fry/not-sure-if-human-or-robot-thumb.jpg",
	"http://troll.me/images/philosoraptor/if-lab-is-all-about-research-development-why-keep-old-robots-thumb.jpg",
	"http://troll.me/images/professor/a-giant-red-robot-wonderful-thumb.jpg"
]

module.exports = (robot) ->
  robot.respond /(.*)(robot|robawt)/i, (msg) ->
	    msg.send msg.random robot_memes
