# Hot Tech Boy of the Week: Zach Holman
# A side-effect of http://social-proof.org/post/18387776795/hot-tech-boy-of-the-week-zach-holman
#
# ask holman - Answer with tech hotness from Zach "Fork Me" Holman
module.exports = (robot) ->
    robot.hear /ask holman/i, (msg) ->
        quotes = [
            "Hard hitting questions right away?",
            "Carnegie Mellon… it’s an… excellent institution.",
            "I can do whatever I want which is kind of rad.",
            "The industry is really lacking in women and it sucks. Look at San Francisco, every meet up you go to is all dudes.",
            "Come on, a pony tail and sucker, what more could you want?",
            "I would get bored by someone who is not independent. By that I mean they actually do shit in the industry.",
            "With these kinds of people I’m uninterested to the point where I get angry at them for being very bland.",
            "I usually just drink gin and tonic… Let me point out that women who like gin are really awesome women.",
            "Rickhouse has the best gin and tonics in San Francisco.",
            "I can't, I’m sitting on a grassy knoll and thinking for a few hours.",
            "I love all women. I don’t prefer a certain race. I mean I hear ya, but I have no preference.",
            "CAN I GET INTO YOUR PANTS",
            "CAN I GET INTO YOUR PANTS\n\nlol jk.\n\nmaybe?",
            "I haven’t used it in practice, but I’ve always wanted to use it.",
            "I use that after I get to know someone and then I actually sink the deal.",
            "It’s pretty rad right?",
            "Come jump on my train!",
            "I was once in an orgy in Rickhouse.",
            "Sometimes it's fun to be a little whimsical.",
            "Sometimes it's fun to be a little creepy.",
            "I WAS AMBUSHED BY THOSE JOURNALISTS THEY PUT WORDS IN MY MOUTH",
            "Mom may have wanted me to be a doctor or something, but hey, \"Hot Tech Boy of the Week\" will do.",
            "Are we going to Rickhouse now?"
        ]
        msg.send msg.random quotes
