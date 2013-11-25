# Description:
#   Simpsons fun.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot simpsons <quote|image> - A Great Simpsons Quote or Image
#
# Author:
#   omardelarosa

module.exports = (robot) ->
  robot.respond /simpsons (.*)$/i, (msg) ->
    option = msg.match[1].trim()
    content =
      # Simpsons Images:
      images: [
        "http://i.imgur.com/kW0f7.jpg",
        "http://i.imgur.com/vw9gZ.jpg",
        "http://i.imgur.com/aV6ju.jpg",
        "http://i.imgur.com/AQBJW.jpg",
        "http://i.imgur.com/tKkRO.png",
        "http://i.imgur.com/lkbGP.png",
        "http://i.imgur.com/mx54e.jpg",
        "http://i.imgur.com/LASrK.jpg",
        "http://i.imgur.com/zvUBG.jpg",
        "http://i.imgur.com/tjqca.jpg",
        "http://i.imgur.com/q5CYv.jpg",
        "http://i.imgur.com/HsoXm.jpg",
        "http://i.imgur.com/6EGQm.jpg",
        "http://i.imgur.com/DxpKu.jpg",
        "http://i.imgur.com/h2c7L.jpg",
        "http://i.imgur.com/jNyXL.jpg",
        "http://i.imgur.com/K09cJ.jpg",
        "http://i.imgur.com/mO0UE.jpg",
        "http://i.imgur.com/9hhkx.jpg"]

      # Quotes Via: http://thoughtcatalog.com/oliver-miller/2012/07/simpsons-quotes-in-order-of-awesomeness/
      quotes: [
        "Lisa, if I've learned anything, it's that life is just one crushing defeat after another until you just wish Flanders was dead.",
        "Sorry mom, the mob has spoken.",
        "…A little help?",
        "So I said to myself: what would God do in this situation?",
        "The goggles, they do nothing!",
        "And I'm not easily impressed — WOW, A BLUE CAR!",
        "Since the beginning of time, man has yearned to destroy the sun.",
        "Lisa, I'd like to buy your rock.",
        "My son's name is also Bort.",
        "We're here! We're queer! We don't want any more bears!",
        "There's an angry mob here to see you, sir.",
        "It's just like I've always said: Democracy doesn't work.",
        "I'd kill you if I had my gun!",
        "'Let's fight.'  '…Them's fightin' words!'",
        "Freedom! Horrible, horrible freedom!",
        "You'll pick many a bean.",
        "Woozle wazzle?",
        "Stupid like a fox!",
        "Maybe there is no moral. Maybe it's just a bunch of stuff that happened.",
        "I'm about to convene another meeting… in bed.",
        "…Jeremy's iron?",
        "‘Learned,' son. The word is ‘learned.'"
        "I see you've played knifey spooney before.",
        "'D'oh!' 'A deer!' 'A female deer.'",
        "Elementary chaos theory shows that all robots must inevitably run amok.",
        "And that little boy who no one liked grew up to be… Roy Cohn.",
        "…Again? This stupid country.",
        "In America, first you get the sugar, then you get the women, then you get the money.",
        "Tramamampoline!",
        "It was a pornography store. I was buying pornography.",
        "Yes! Crisertunity!",
        "There's bound to be a little splash-back.",
        "Three simple words: I am gay.",
        "Simpson, Homer Simpson/ He's the greatest guy in history/ From the/ Town of Springfield/ He's about to hit a chestnut tree.",
        "Ahoy ahoy?",
        "'Lord Palmerston!' '…Pitt the Elder.'",
        "'Are these idiots getting louder or dumber?' '…Louder, sir.'",
        "I really like the vest.",
        "That's the funniest anecdote that I've ever heard! Now, why don't you tell one?",
        "Well, we hit a slight snag when the universe collapsed in on itself.",
        "Abortions for some, miniature American flags for others!",
        "What was I laughing about? Oh, yes. That crippled Irishman.",
        "You'll release the dogs, or the bees, or the dogs with bees in their mouths, and when they bark, they shoot bees at you?",
        "She's faking it.",
        "My god! It's like a party in my mouth and everyone's invited.",
        "I'm fired, aren't I?",
        "Don't criticize the boat!",
        "Disco Stu… likes disco.",
        "'Yes! In your face, space coyote!'  '…Space coyote?'"
        "Worst… episode… ever.",
        "Up and at them!",
        "Aw! Look at that little baby axe!",
        "Yeah, well, we saved your asses in World War III.",
        "Because he gets results, you stupid chief!!!",
        "'There's an adorable little boy here to see you sir.' '…Release the hounds.'",
        "Well, Homer. I earned your respect. And all I had to do was save your life. Now, if every other gay person could save your life, we'd be set.",
        "Now they'll never save your brain, Hitler!",
        "'This is a dog who gets biz-ay. Consistently and thoroughly.' '…So he's proactive?'",
        "How ironic.",
        "That does it! Go to your room!",
        "There is one more way to kill a man, but it is as intricate and precise as a well-played game of chess.",
        "We need a name that's witty at first, but that gets less funny each time you hear it.",
        "In case you didn't real-ize, I was being sarcastic.",
        "Now, I don't care, nothing's going to stop me in the middle of this sente — LEMON TREE?!",
        "Mr. Simpson, I don't use the word ‘hero' very often. But you, sir, are the greatest America hero who has ever lived.",
        "You've crossed the line from regular villainy into cartoonish super-villainy.",
        "I wish they wouldn't scream.",
        "Put it in ‘H'!",
        "Sure, the Germans have made a few mistakes, but that's why pencils have erasers!",
        "C'est Troy bien!",
        "Dig up, stupid!",
        "It looks as though the fox has been caught by exactly the person who was trying to catch it.",
        "The Lincoln Squirrel has been assassinated!",
        "FOX turned into a hardcore sex channel so gradually, I didn't even notice.",
        "Stop, stop! He's already dead.",
        "Truly, yours is a butt that will not quit.",
        "Come, family. Let us all bathe in TV's warm glowing glowy glow.",
        "My boy is a box! Damn you! He's a box!",
        "You might say, there's a little Uter in all of us.",
        "No beer and no TV makes Homer go something something.",
        "Is this the end of Zombie Shakespeare?!",
        "Aw, there's always a canal!",
        "I'm sorry. I shouldn't have stopped to get that haircut.",
        "Keep watching the skis!",
        "I filched it whilst you weren't looking. And when your back is turned, I'll do it again.",
        "I like the way this Snrub thinks!",
        "…I was saying ‘Boo-urns.'",
        "I felt such a feeling of power, like God must feel when he's holding a gun.",
        "Show business is so horribly repetitive. I've said the words ‘jiminny-jilkers' so many times that they've lost all meaning.",
        "So one of those Egg Council creeps got to you too, huh?",
        "Good thing I drink plenty of… malk?",
        "This town is a part of us all, a part of us all, a part of us all.",
        "'Well, that's certainly specious reasoning, Dad.' '…Thank you, honey.'",
        "Marge, my pet, I haven't learned a thing.",
        "I call the big one 'Bitey.'",
        "Wow, with a cool dry wit like that, I could be an action hero.",
        "I noticed that he was wearing sneakers. For… sneaking.",
        "…You're in direct competition with each other! Fight, fight, fight, fight, fight, fight, fight!",
        "They're getting away… very slowly.",
        "…If anyone needs me, I'll be in my room."]

    switch option
      when "quote" then msg.send msg.random content.quotes
      when "image" then msg.send msg.random content.images
      else msg.send "D'oh! Don't know that option!"
