# Description:
#   Random quote from Jesse Pinkman of Breaking Bad
#
# Commands:
#   hubot pinkman me bitch - Random quote from Pinkman
#
# Author:
#   Micah Martin

module.exports = (robot) ->

	quotes = [
		"Yo!",
		"Bitch!"
		"Yo...Bitch!",
		"Gatorade me bitch!",
		"Look, I like making cherry product, but let's keep it real, alright? We make poison for people who don't care. We probably have the most unpicky customers in the world.",
		"Possum. Big, freaky, lookin' bitch. Since when did they change it to opossum? When I was comin' up it was just possum. Opossum makes it sound like he's irish or something. Why do they gotta go changing everything?",
		"Dude, you scared the shit out of me. When you say it's contamination. I mean, I'm thinking like... an ebola leak or something. Yeah, it's a disease on the Discovery Channel where all your intestines sort of just slip right out of your butt.",
		"Yo, I get I shouldn't call, but I'm in a situation over here, and I need my money. Yeah, and thanks, Daddy Warbucks, but that was before my housing situation went completely testicular on me, okay?",
		"Spooge? Not Mad Dog? Not Diesel? So lemme get this straight, you got jacked by a man named Spooge?",
		"No, no, chili P is my signature!",
		"For what it's worth, getting the shit kicked out of you? Not to say you get used to it, but you do kinda get used to it.",
		"I got two dudes that turned into raspberry slushie and flushed down my toilet.",
		"Oh well, heil Hitler, bitch!",
		"Yo yo yo, 1 4 8, 3 to the 3, to the 6, to the 9, representin' the ABQ. What up, biatch? Leaveth tone.",
		"This is my own private domicile and I will not be harassed... bitch!",
		"You're my free pass... bitch",
		"You can't order shit, Adolf.",
		"Yeah Bitch! Magnets!",
		"Yeah Mr. White. YEAH SCIENCE!",
		"What's the point of being an outlaw if I gotta have responsibilities?",
		"You either run from things or you face them, Mr. White. I learned it in rehab. It's all about accepting who you really are. I accept who I am. I'm the bad guy.",
		"Got some big cow house way out that way, like two miles, but I don't see nobody. Yeah, where they live... the cows!"
	]

	robot.respond /pinkman me bitch/i, (msg) ->
		randIndex = Math.floor((Math.random()*quotes.length)+1)
		msg.send quotes[randIndex - 1]


