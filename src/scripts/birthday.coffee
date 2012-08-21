# Description:
#   Delegate your birthday greetings, celebrations and quotes to Hubot.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot birthday quote for <user> -- congratulate <user> with a random birthday quote
#   hubot celebrate me <user> -- congratulate <user> with an inspirational greeting 
#   hubot happy birthday me <user> -- congratulate <user> with a humorous greeting
#
# Author:
#   sopel

module.exports = (robot) ->

  robot.respond /(birthday quote)( for )?(.*)/i, (msg)->
    name = msg.match[3].trim()
    if name.length == 0
      msg.send(quote())
    else
      msg.send(name + " - here's a quote for you: ")
      msg.send(quote(name))

  robot.respond /(happy birthday)( me )?(.*)/i, (msg)->
    name = msg.match[3].trim()
    if name.length == 0
      msg.send(quote())
    else
      msg.send(greeting(name))
  
  robot.respond /(celebrate)( me )?(.*)/i, (msg)->
    name = msg.match[3].trim()
    if name.length == 0
      msg.send("You must be kidding.")
    else
      msg.send(celebrate(name))

celebrate = (name) ->
  celebrates[(Math.random() * celebrates.length) >> 0].replace(/{name}/, name);

celebrates = [
  "{name} - Hoping that your day will be as special as you are.",
  "{name} - Count your life by smiles, not tears. Count your age by friends, not years.",
  "May the years continue to be good to you. Happy Birthday {name}!",
  "{name} - You're not getting older, you're getting better.",
  "{name} - May this year bring with it all the success and fulfillment your heart desires.",
  "{name} - Wishing you all the great things in life, hope this day will bring you an extra share of all that makes you happiest.",
  "Happy Birthday {name}, and may all the wishes and dreams you dream today turn to reality.",
  "May this day bring to you all things that make you smile. Happy Birthday {name}!",
  "{name} - Your best years are still ahead of you.",
  "{name} - Birthdays are filled with yesterday's memories, today's joys, and tomorrow's dreams.",
  "{name} - Hoping that your day will be as special as you are.",
  "{name} - You'll always be forever young."
]
greeting = (name) ->
  greetings[(Math.random() * greetings.length) >> 0].replace(/{name}/, name);

greetings = [
  "Happy Birthday {name}, you're not getting older, you're just a little closer to death.",
  "Birthdays are good for you {name}. Statistics show that people who have the most live the longest!",
  "{name} - I'm so glad you were born, because you brighten my life and fill it with joy.",
  "{name} - Always remember: growing old is mandatory, growing up is optional.",
  "{name} - Better to be over the hill than burried under it.",
  "You always have such fun birthdays {name}, you should have one every year.",
  "Happy birthday to {name}, a person who is smart, good looking, and funny and reminds me a lot of myself.",
  "{name} - We know we're getting old when the only thing we want for our birthday is not to be reminded of it.",
  "Happy Birthday on your very special day {name}, I hope that you don't die before you eat your cake."
]

quote = () ->
  quotes[(Math.random() * quotes.length) >> 0];

quotes = [
  "Our birthdays are feathers in the broad wing of time. - Jean Paul Richter",
  "Inside every older person is a younger person wondering what happened. - Jennifer Yane",
  "Wisdom doesn't necessarily come with age. Sometimes age just shows up all by itself. - Tom Wilson",
  "May you stay forever young. - Bob Dylan",
  "The old believe everything; the middle-aged suspect everything; the young know everything. - Oscar Wilde",
  "Old age is like everything else. To make a success of it, you've got to start young. - Fred Astaire",
  "Age is a number and mine is unlisted. - Unknown",
  "When I was younger, I could remember anything, whether it happened or not.- Mark Twain",
  "Whatever with the past has gone, The best is always yet to come. - Lucy Larcom",
  "It takes a long time to grow young. - Pablo Picasso",
  "Few women admit their age. Few men act theirs. - Unkown",
  "The best way to remember your wife's birthday is to forget it once. - H. V. Prochnow"
]
