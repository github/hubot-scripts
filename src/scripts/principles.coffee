# Description:
#   Gives out advise about relationships and communication
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot principle me  - Respond with a random principle
#   hubot principle all - Respond with ALL the principles (Big paste)
#
# Author:
#   Devin Weaver (@sukima)
#   Orignial work by Franklin (tacit) from http://tacit.livejournal.com/388290.html

principles = [
  "You can not expect to have what you want if you do not ask for what you want."
  "Just because you feel bad doesn’t necessarily mean someone did something wrong."
  "Just because you feel good doesn’t necessarily mean that what you’re doing is right."
  "Integrity matters—not for the people around you, but for you."
  "Life rewards people who move in the direction of greatest courage."
  "An expectation on your part does not incur an obligation on someone else’s."
  "When you feel something scary or unpleasant, talk about it."
  "Your partners add value to your life; treat them preciously."
  "Make sure your partner’s heart is safe in your hands."
  "The easiest way to attract people with the qualities you desire is to be the sort of person that someone with those qualities finds interesting."
  "People are not commodities."
  "There are a whole lot of things your partner will do that are Not About You."
  "Different people express love in different ways; learn to recognize the way your partner speaks of love, so that you know it when you see it."
  "Don’t treat people the way you’d have them treat you; treat them the way they’d have you treat them."
  "Pay attention."
  "We are all born of frailty and error; it is important that we forgive one another’s failings reciprocally."
  "Being in a relationship that does not meet your needs is not necessarily better than being alone."
  "Love is abundant."
  "It is not necessary to be the best at everything, nor even the best at anything; alone of all the people in the world, only you bring your unique mix of qualities to the table."
  "Relationships entered into from conscious choice are often more rewarding than ones entered into out of default assumptions."
  "Don’t play games, especially with other people’s hearts."
  "The things you think are important when you’re theorizing about relationships are not always the things that turn out to be important."
  "Be flexible."
  "A relationship with a partner who chooses, every day, to be with you is more satisfying than a relationship with a partner who is with you because he or she can’t leave."
  "Real security comes from within."
  "People are not need fulfillment machines."
  "Don’t look to others to complete you."
  "Change is a part of life."
  "Occasionally, you will feel awkward, uncomfortable, or both; that’s normal, and not something to be feared."
  "We are all lousy at predicting how we will respond to new or unfamiliar situations."
  "When you hurt someone—and you will—suck it up, take responsibility for it, and do whatever you can to make it right."
  "There will be times when relationships end; it doesn’t mean they were a failure, or that the other person is a bad person."
  "Your heart will, at some point, almost certainly be broken, and that’s okay; you will survive, and find love again."
  "Feelings are not fact."
  "Fear of intimacy is the enemy of happiness."
  "The times when compassion is the most difficult are the times when it’s most necessary."
  "Don’t vilify those who hurt you; they are still people, too."
  "It is possible to deeply, profoundly love someone to the bottom of your heart and still not be a good partner for that person."
  "Being uncomfortable is not , by itself, a reason not to do something."
  "It is almost impossible to be generous or compassionate if all you feel is fear of loss."
  "The world is the way it is, not the way we want it to be."
  "Life’s song is filled with beauty and chaos and joy and sorrow and pain and uncertainty and ecstasy and heartache and passion; to fear any of these things is to fear life."
]

module.exports = (robot) ->

  robot.respond /principle me/i , (msg) ->
    msg.send msg.random principles

  robot.respond /principle (all|bomb)/i, (msg) ->
    msg.send principles.join("\n")
