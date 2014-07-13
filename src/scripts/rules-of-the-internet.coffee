# Description:
#   Return the Rules of the Internet
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rule <number> - Returns rule <number>
#   hubot rule list - Returns a list of all rules
#
# Author:
#   A. Gianotto - @snipe

rules = 
	1: "Do not talk about /b/."
	2: "Do NOT talk about /b/."
	3: "We are Anonymous."
	4: "Anonymous is legion."
	5: "Anonymous never forgives."
	6: "Anonymous can be a horrible, senseless, uncaring monster."
	7: "Anonymous is still able to deliver."
	8: "There are no real rules about posting."
	9: "There are no real rules about moderation either - enjoy your ban."
	10: "If you enjoy any rival sites - DON'T."
	11: "All your carefully picked arguments can easily be ignored."
	12: "Anything you say can and will be used against you."
	13: "Anything you say can be turned into something else - fixed."
	14: "Do not argue with trolls - it means that they win."
	15: "The harder you try the harder you will fail."
	16: "If you fail in epic proportions, it may just become a winning failure."
	17: "Every win fails eventually."
	18: "Everything that can be labeled, can be hated."
	19: "The more you hate it the stronger it gets."
	20: "Nothing is: to be taken seriously."
	21: "Original content is: original only for a few seconds before getting old."
	22: "Copypasta is: made to ruin every last bit of originality."
	23: "Copypasta is: made to ruin every last bit of originality."
	24: "Every repost is: always a repost of a repost."
	25: "Relation to the original topic decreases with every single post"
	26: "Any topic can be turned into something totally unrelated."
	27: "Always question a person's sexual preferences without any real reason."
	28: "Always question a person's gender - just in case it's really a man."
	29: "On the internet all girls are men and all kids are undercover FBI agents."
	30: "There are no girls on the internet."
	31: "TITS or GTFO - the choice is: yours."
	32: "You must have pictures to prove your statements."
	33: "Lurk more - it's never enough."
	34: "There is: porn of it, no exceptions."
	35: "If no porn is: found at the moment, it will be made."
	36: "There will always be even more fucked up shit than what you just saw."
	37: "You can not divide by zero (just because the calculator says so)."
	38: "No real limits of any kind apply here - not even the sky."
	39: "CAPSLOCK is CRUISE CONTROL FOR COOL."
	40: "EVEN WITH CRUISE CONTROL YOU STILL HAVE TO STEER."
	41: "Desu isn't funny. Seriously guys. It's worse than Chuck Norris jokes."
	42: "Nothing is Sacred."
	43: "The more beautiful and pure a thing is: - the more satisfying it is: to corrupt it"
	44: "Even one positive comment about Japanese things can make you a weeeaboo."
	45: "When one sees a lion, one must get into the car."
	46: "There is: always furry porn of it."
	47: "The pool is: always closed."

module.exports = (robot) ->
  robot.respond /rule (.*)/i, (msg) ->
    rule = msg.match[1].toLowerCase()
    if rule=="list"
      summary = "Rules of the Internet: \n"

      for index, element of rules
        summary += "Rule #{index}: #{rules[index]} \n" 
      
      msg.send summary
    else    
      if rules[rule]
        msg.send "Rule #{rule}: #{rules[rule]} " 
      else 
        msg.send "No such rule, sucka" 