# Description:
#   SHIT BEN BLACK SAYS 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   ask b6n - Answer with random wizdom from Benjamin Black
#
# Author:
#  chids

module.exports = (robot) ->
    robot.hear /ask b6n/i, (msg) ->
        quotes = ["reading is fundamental",
        "apparently it’s a bad idea to run a large database on a handful of puny rackspace cloud instances.\nwho knew?",
        "totally resharded",
        "that’s not an error, not finding php is an indication things are as they should be",
        "swap mostly poop",
        "i leave you to your overthinking",
        "i have no idea what you think you are measuring at this point\nyou are running riak in a way that is neither the way it was intended to run nor the way you intend to run it.",
        "yeah, so, if you could never say \"shard\" again in the context of a dynamo system that’d be awesome",
        "that’s not scale, that’s a rails app.",
        "right, i see your problem now. you are doing soemthing terrible.",
        "yes, many things can be done with enough of the right code\nbut resources are finite\ndirectly accessing a database from the front end app like that is just poor practice. put a service in front of it that exposes an app-appropriate interface (NOT a native db interface)\nas needed, swap out backend\nas needed, scale out that layer"
        "the code provided with cassandra works. yours doesn’t. ergo, the problem is in your code.",
        "what i said is either do it properly or not at all.",
        "you didn’t just believe some bullshit in techcrunch, did you?",
        "you put an APP written in a REAL LANGUAGE in front of the data store\nit exposes an interface specific to your FRONT END",
        "meanwhile, back in reality: use the right tool for the job.",
        "as much as i would enjoy talking in contradictory circles with you, i am out of power",
        "somebody should remind php that hashes and void pointers do not a type system make.",
        "sorry, i’m lost\nyou have no idea what the real problem is, you don’t know what the architecture is, you don’t know what storage you will need, but you know you are starting with 4 nodes.",
        "scale breaks everything.",
        "thrift is crap.",
        "so\nagain\nwhat's confusing you",
        "you’re already wrong, but do go on.",
        "*facepalm*",
        "i have no constructive response for you.",
        "i’d ask why but i don’t care",
        "if you aren’t willing to read documentation and sample code then there isn’t much i can do to help."]
        msg.send msg.random quotes
