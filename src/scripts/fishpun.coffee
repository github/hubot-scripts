# Description:
#   Horrible Animal Crossing fish puns
#
# Dependencies:
#   None
# 
# Configuration:
#   None
#
# Commands:
#   fish - Get fishy
#
# Author:
#   BM5k

module.exports = (robot) ->
  robot.hear /fish/i, (msg) ->
    quotes = [
      "I caught an angelfish! It looks divine!",
      "I caught an arapaima! This thing is huge!",
      "I caught an arowana! It's the golden dragon fish! I wonder what it's worth...",
      "I caught a barbel steed! That's funny...It looks more like a fish than a horse.",
      "I caught a barred knifejaw! I'm really cut-up over how to turn this into a pun...",
      "I caught a bass! If I can catch a drummer, maybe I'll form a band!",
      "I caught a bitterling! I wonder what makes this little guy so angry...",
      "I caught a bluegill! Don't worry I caught the rest of the fish, too!",
      "I caught a brook trout! I guess that little guy's just trOUT of luck!",
      "I caught a carp! Ouch! I hurt my wrist! It might be CARPal-tunnel!",
      "I caught a catfish! I think I'll name it Whiskers...",
      "I caught a cherry salmon! It looks so PITiful! Get it? Pit? Oh, never mind.",
      "I caught a coelacanth! Would you look at that! A living fossil. I didn't know they truly existed.",
      "I caught a crawfish! Check out those pincers!",
      "I caught a crucian carp! Carpe diem!",
      "I caught a dace! Daces wild!",
      "I caught an eel! I've been told they're rEELy tough to catch (I'm sorry).",
      "I caught a freshwater goby! Go me, goby!",
      "I caught a frog! Think I should kiss it? (Ew...it's all warty!)",
      "I caught a giant catfish! (That's because I used a giant mousefish as bait!)",
      "I caught a giant snakehead! Yep! A giant snakehead. Who names these things?",
      "I caught a goldfish! It's worth its weight in...fish. Great.",
      "I caught a guppy! He ate an awful lot of bait for being so tiny!",
      "I caught a jellyfish! I wonder how it would taste on some toast...",
      "I caught a killifish! Killer!",
      "I caught a koi! Whoever colored it did a real good job.",
      "I caught a large bass! Well, it's pretty big...I guess...",
      "I caught a large char! I wonder what it tastes like CHAR-broiled...",
      "I caught a loach! You don't suppose it's Hylian, do you?",
      "I caught a pale chub! Looks like it could use a little sun...and a little diet",
      "I caught a piranha! Which river is this, anyway? I'm glad I didn't take a dip!",
      "I caught a pond smelt! Whew! And I thought the POND smelt bad!",
      "I caught a popeyed goldfish! Aw, look... He wants his spinach...",
      "I caught a rainbow trout! Now that's a trout of a different color!",
      "I caught a red snapper! That was a snap! (I really have to stop saying things like that.)",
      "I caught a salmon! And it made it all the way back here! Now i feel bad.",
      "I caught a sea bass! See? Bass! (Why do I keep saying things like that?)",
      "I caught a small bass! Now, I just need to catch a small bass amp. (Oh, that was terrible...)",
      "I caught a stringfish! Ohhh, boy! I hooked a stringfish! I was just stringing it along...",
      "I caught a sweetfish! And let me tell you, that is one SWEET fish!"
    ]
    msg.send msg.random quotes
