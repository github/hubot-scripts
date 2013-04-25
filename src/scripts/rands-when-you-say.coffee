# Description
#   A slightly incomplete collection of "When you say..." tweets from @rands
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rands - A nugget of Randsian wisdom is dispensed
#   hubot rands count - The number of wisdom nuggets is returned 
#
# Notes:
#   None
#
# Author:
#   pberry

module.exports = (robot) ->
  wisdom = [
    "Management works when you actually mean what you say. http://twitter.com/rands/statuses/11309449247",
    "When you say \"unique leadership style,\" I hear \"jerk.\" https://twitter.com/rands/status/289893035150569472",
    "When you say \"Not invented here,\" I hear \"It'd be more fun to build it.\" https://twitter.com/rands/status/214741618916466689",
    "When you say \"Monetizing eyeballs,\" I hear \"We're going to stop building the stuff that matters.\" https://twitter.com/rands/status/217635293484945408",
    "When you say “Detail oriented,” I hear “Gives a shit.” https://twitter.com/rands/status/220188892094152704",
    "When you say \"I'll be the first to admit,\" I hear \"Everyone has been telling me I should admit this.\" https://twitter.com/rands/status/226375945521610753",
    "When you say \"I trust your judgement,\" I hear \"I trust that you think you know better, but it will be entertaining to watch you fail.\" https://twitter.com/rands/status/235153466081808385",
    "When you say \"I'm not suggesting,\" I hear \"I'm disguising my suggestions.\" https://twitter.com/rands/status/236987129513775104",
    "When you say \"infrastructure play,\" I want to punch you. https://twitter.com/rands/status/237919382687334400",
    "When you say \"Let's get on the same page,\" I hear, \"Let's get on my page.\" https://twitter.com/rands/status/243698273116889088",
    "When you say \"Go forward plan,\" I hear \"It's more important to go forward than have a plan.\" https://twitter.com/rands/status/244821499880562688",
    "When you say \"Build awareness,\" I hear \"Listen to me more.\" https://twitter.com/rands/status/245540962162593793",
    "When you say \"Soon,\" I hear \"I don't know when.\" https://twitter.com/rands/status/247686950448943104",
    "When you say \"It's really easy,\" I hear \"I wish it was really easy.\" https://twitter.com/rands/status/248565054948130817",
    "When you say \"Normalize,\" I hear \"Improve legibility\" and then I sleep better at night. https://twitter.com/rands/status/252794850494267392",
    "When you say \"Nothing is changing,\" I hear \"Yet.\" https://twitter.com/rands/status/253970014825218048",
    "When you say \"A fundamental shift in business,\" I hear \"We'll be losing money for awhile\" : http://www.theverge.com/2012/10/9/3480696/steve-ballmer-shareholder-letter-2012-devices-services https://twitter.com/rands/status/255896683571978240",
    "When you say “Conventional wisdom,” I hear “Path of least resistance.” https://twitter.com/rands/status/259162088503664640",
    "When you say, “Falling through the cracks,” I hear “I don’t know why it’s breaking.” https://twitter.com/rands/status/261866058628091904",
    "When you say \"Service event,\" I hear \"We are bullshitting you about the facts\" : http://t.co/LFzQFnOD https://twitter.com/rands/status/262089106551619585",
    "When you say “Absolutely!” I hear “I am not fond of ambiguity.” https://twitter.com/rands/status/264393818214899712",
    "When you say “We need to work on that,” I hear “Never.” https://twitter.com/rands/status/273951473157689344",
    "When you say “Bespoke,” I can’t stop thinking about bicycles. https://twitter.com/rands/status/275841713367556096",
    "When you say \"Quaint,\" I hear \"I can't be bothered to imagine that things could change.\" https://twitter.com/rands/status/280899714336038912",
    "When you say \"Relaunch,\" I hear, \"The pivot isn't working.\" https://twitter.com/rands/status/281822856877322240",
    "When you say \"Design-y\", I stop listening. https://twitter.com/rands/status/289485121361424384",
    "When you say “It’s simple”, I hear “I don’t have to explain why it’s hard”. http://twitter.com/rands/statuses/28432698384",
    "When you say “You suck”, I think “I win”. http://twitter.com/rands/statuses/6472192856",
    "When you say “Thought leader”, I hear “You talk pretty”. http://twitter.com/rands/statuses/26584224990",
    "When you say “Friendly reminder,” I hear “I will mess you up if you miss this deadline.” http://twitter.com/rands/statuses/202847708271230976",
    "When you say “I trust your judgement,” I hear “I trust that you think you know better, but it will be entertaining to watch you fail.” http://twitter.com/rands/statuses/235153466081808385",
    "When you say “It’s complicated,” I hear, “You aren’t going to like the answer.” http://twitter.com/rands/statuses/189203032905494529",
    "When you say “Offsite”, I hear “Boondoggle”. http://twitter.com/rands/statuses/99521172005326848",
    "When you say “Let’s send a message”, I hear “We don’t actually know what to say.” http://twitter.com/rands/statuses/139152607083102208",
    "When you say “I’m a straight talker”, I hear “I don’t care that you don’t understand me”. http://twitter.com/rands/statuses/20333834621",
    "When you say “Sure”, I don’t hear “Yes.” http://twitter.com/rands/statuses/133345216886345729",
    "When you say “The facts are”, I hear “These are the facts I want you to know.” http://twitter.com/rands/statuses/156172596143063040",
    "When you say “You hit the nail on the head”, I hear “I wish I thought of that.” http://twitter.com/rands/statuses/108597258055979008",
    "When you say “He’s the real deal,” I think “What deal do you think I think he is?” http://twitter.com/rands/statuses/189049908639186944",
    "When you say “Hang tough”, I hear “We have no better strategy than letting you stand there being punched”. http://twitter.com/rands/statuses/4345861202",
    "When you say “A learning mindset”, I hear “I’m about to use big words that I don’t expect you to understand”. http://twitter.com/rands/statuses/21933940584",
    "When you say “Executive Coach”, I hear “Expensive common sense”. http://twitter.com/rands/statuses/25998859249",
    "When you say “Have to”, I hear “Don’t want to.” http://twitter.com/rands/statuses/131426938597277696",
    "When you say “Iterate”, I try to hear “Working until it’s great” rather than “Working endlessly because you can’t describe done.” http://twitter.com/rands/statuses/158647734558138368",
    "When you say “Technical debt,” I hear “We’ve been hacking.” http://twitter.com/rands/statuses/182492475724800001",
    "When you say “We’ll cross that bridge when we get to it”, I hear “I agree this is my task, but I don’t care”. http://twitter.com/rands/statuses/56076748953092098",
    "When you say “Thank god it’s Friday”, I hear “I hate my job”. http://twitter.com/rands/statuses/43792659864760320",
    "When you say “Crowd-sourced”, I hear “We have no plan” : http://techcrunch.com/2011/04/01/color-updates-its-iphone-app-with-new-more-intelligible-icons-navigation/ http://twitter.com/rands/statuses/54290475783421952",
    "When you say “Most people,” I hear “All the dumb people except me.” http://twitter.com/rands/statuses/152954436640182273",
    "When you say “Hope” to an engineer, they hear “I have no credible plan”. http://twitter.com/rands/statuses/22001311155228674",
    "When you say “We’re experiencing growing pains”, I hear “I didn’t think of that”. http://twitter.com/rands/statuses/53247126817345537",
    "When you say “It is what it is”, I hear “I have totally given up”. http://twitter.com/rands/statuses/19513088389",
    "When you say “Glaring blind spot”, I hear “Yeah, I didn’t see that coming, either”. http://twitter.com/rands/statuses/22581884963",
    "When you say “All things being equal”, I hear “I’m confused why things aren’t equal.” http://twitter.com/rands/statuses/93400188479221760",
    "When you say “Whatever”, I don’t hear much because I’m grinding my teeth with fury. http://twitter.com/rands/statuses/156260385010356224",
    "When you say “Better is the enemy of done”, I hear “It’s ok to ship crap” http://twitter.com/rands/statuses/2793071211",
    "When you say “Go Forward Plan” I hear “I picked a direction and called it forward” http://twitter.com/rands/statuses/14458189005",
    "When you say “Perhaps it’s just me,” I hear “Yeah, everyone should think like I do.” http://twitter.com/rands/statuses/193155583938002944",
    "When you say “The powers that be”, I hear “I have absolutely no authority in this matter”. http://twitter.com/rands/statuses/22031352673",
    "When you say “a mix of personalities,” I hear “a couple of folks that drive me crazy.” http://twitter.com/rands/statuses/182113521876729856",
    "When you say “I hate it”, I hear “I don’t have the time to actually have an opinion”. http://twitter.com/rands/statuses/24694739571",
    "When you say “organizational efficiency expert”, I hear “ABHJKJDHhuASDKJH BHS SAD SAHJJHASDJH NAHJASDHAJS” (sfx: my head hitting keyboard) http://twitter.com/rands/statuses/26384939022",
    "When you say “It’s an imprecise science”, I hear “I am fully making this up as I go.” http://twitter.com/rands/statuses/159808299779358720",
    "When you say “Let’s cut through the bullshit”, I hear “You‘re not telling me what I want to hear”. http://twitter.com/rands/statuses/11876666225725440",
    "When you say “I don’t care”, I often hear “I don’t want to deal with the consequences of deciding”. http://twitter.com/rands/statuses/19799390667415552",
    "When you say “Cost Effective”, I hear “I’m too busy to understand value in any other terms than money.” http://twitter.com/rands/statuses/132114748086030337",
    "When you say, “You‘re the boss” I hear “We got together and all agree that you‘re about to screw this up” http://twitter.com/rands/statuses/6090022746",
    "When you say “It wasn’t meant to happen”, I hear “We don’t know or can’t explain how we screwed up.” http://twitter.com/rands/statuses/144102532220858368",
    "When you say “The last thing I want to happen is”, I hear “This is what I expect to occur”. http://twitter.com/rands/statuses/83340096601993216",
    "When you say “Well, you‘re lucky that..”, I hear “Well, I have absolutely no control or influence over this situation”. http://twitter.com/rands/statuses/52036340375764992",
    "When you say “No Meeting Wednesday,” I hear, “We’ve let meetings take over.” https://twitter.com/rands/status/294480995644743680",
    "When you say “Sinus infection,” I hear, “I’m fully in denial that I am sick.” https://twitter.com/rands/status/306933143703781377",
    "@IAmRoot When you say “management consultants,” I die a little inside. https://twitter.com/rands/status/300290819913555972"
  ]
  robot.respond /rands$/i, (msg) ->
    msg.send msg.random wisdom
  robot.respond /rands count$/i, (msg) ->
    msg.send("I currently have #{wisdom.length} Randisms in my database.")

