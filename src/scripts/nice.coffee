# Fill your chat with some kindness
#
# hubot be nice - just gives some love :)

###
found some greate quotes on http://www.quotegarden.com/smiles.html
###

###
Written by Ole 'nesQuick' Michaelis (Ole.Michaelis@googlemail.com)
Follow me on Twitter (@CodeStars)
Digital Pioneers N.V. - WE ARE HIRING (http://digitalpioneers.de/jobs)
###

hugs = [
  "You are awesome!",
  "A laugh is a smile that bursts.",
  "=)",
  "Everyone smiles in the same language.",
  "Thank you for installing me."
]

module.exports = (robot)->
  robot.respond /be nice/i, (message)->
    rnd = Math.floor Math.random() * hugs.length
    message.send hugs[rnd]