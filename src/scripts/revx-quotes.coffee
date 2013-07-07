# Description:
#   Returns a random Reverend X / Spirit of Truth quote
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   preach - Returns a random Reverend X quote
#
# Notes:
#   If you don't know who Reverend X / Spirit of Truth, here's an intro:
#   http://www.youtube.com/watch?v=MwsWskgKe5E
#
# Author:
#   jonahoffline (Jonah Ruiz)

quotes = [
  "I can't see you, though, bitch, you see me. I'm all ou- I'm all out. I make my ass very available. Time, next caller... You don't like it? Kiss my ass, you don't like it. It's my house.",
  "The fuck the book I got in my hand.",
  "You don't know em'? You don't know em'?",
  "You don't know? Ha Ha - Look like the yellow pages. A-ha - you killin' me, next caller! Like I said, I come in the name of Jesus by the power of the Holy Spirit; this is - I ain't playin' with yo ass, don't call up and play with me. Next caller, MiMi?",
  "I don't give a fuck what you think, bitch!",
  "Your thoughts - your thoughts ain't my thoughts!",
  "Bitch, I'm flowin' straight from the survival scrolls! Cut that bitch off! Next caller.",
  "What's happening?",
  "What's happening? I come in the name of Jesus by the power of the Holy Spirit. Who name you comin' in?",
  "By who power?",
  "Is what?",
  "Its the spirit of god, you see the spirit of god is ennipetent and it words on ya - it will work on yo ass and I can be far far away it's considering conscious you know? It ain't fillin' my conscious cause I sent by - sent by Jesus to do what I'm doin', it's all, I keep it all lawful and legal. I come in the name of Jesus by the power of the Holy Spirit; any, anybody, anybody resistin' can goddamn my ass kissin'!",
  "I come in the name of Jesus by the power of the Holy Spirit; it don't matter if you come with me, is you down - doing what I'm talkin' about doin'? Lawyers get this book opened, trained in these words and get the poor, the fatherless and the widows up out of the penitentary - you down with that? Shut yo damn ass up!",
  "Give me - give me the next caller.",
  "Hey Motherfucker, I ain't no corrupt corru- communication came out mah mouf. You know what the corrup-corru-minication is? That's when you talk about the devil 'he the devil!' Yo'-yo' motherfuckin' communications is corrupt. Whateva! Whateva 'den I'm wrong! You got me now! You got me now! You got me now, oh, you figured me out, you fuckin' nincom-fucking-poop. You figured me out! You got me red han'ed! You got me red han'ed! God allow, he tell me I'm god 2-1. God liar, huh? I have you - I don't see any of you asses baring witness for me or Jesus - I can't see none of you publishing peace. This is - Jesus is the way to peace. Fuck what you talkin' about! Passion, Passion can you see me?",
  "And what you got to say?",
  "...That make a man offended towards, and lay a snare...' You know, they try and trip a nigga up, like me, you know 'cause I ain't-I ain't followin' whitey's rules! You know...",
  "Are ya laughin', biotch?",
  "Are ya laughin', biotch? Ha, aha! You find it funny? Heh. You find it funny? So, wait, you ain't- you ain't hear me, huh? I'll conversate again: I come in the name of Jesus - repeat it after me, bitch! - I come in the name of Jesus by the power of the Holy Spirit. God Almighty! You know, ruler of Heaven and Earf [Earth], and every goddamn thing in between! You understand me now?",
  "Reverend X! Speak to me-state yo' name-yo' name-first and last name. Talk to me. Correct God! Correct God, ain't none of ya'll correct me by my word, huh? I'll give you some scriptures. Revelation 16:5-6 Revelation 15:4 Ezekiel Chapter 5 verse 15.",
  "Caller - caller you on the line. ",
  "Charles. Yeah! Say what? Mutherfucker I ain't lookin for you! You - you - you probably lookin' for a cult. Muh-fucka, you- get to Heaven's gate, travel the hell up outta here!",
  "Look what? Whatchu know about the Lord? What do you know about the Lord? Whatchu know about the Lord? Don't tell me- I come in the name of Jesus by the power of the Holy Spirit.",
  "Let's stay focused..! You wanna speak on flesh. You on cause you see flesh and shit - You know whitey always told you uh a man can't be god. Huh! What you calling me for. I told you what I'm about - it's about gettin' ( ) train them up with the words and scriptures and we're going to help the poor ( ) that can't afford the legal - legality fees - they can't afford justice. I know you all in for justice huh? Just like white supremacists huh? White supremacists place judgement for you ass and free you from the ( ) blind man!",
  "Next caller, John. John - go ahead! EY, what's happening? Say what? Say what? You trust in the Devil, huh? Well, if God sent the devil, in the name of Jesus by the power of the Holy Spirit, then, motherfucker, you fucked up, huh? You fucked up, huh? You know yo' ass is doomed! Whatchu got to speak? If you don't know shit to speak on some topic I'm bringing up, shut your goddamn ass up....ahah!!",
  "hell!!! you trust in hell motherfucker and you already in hell, just like I trust in heaven and I'm already there motherfucker. You the one goin..you believe in death huh! god damn murderers, crucified my blessed brother, but when I find them I'm gon get them motherfuckers!!!!...",
  "They be the ones thats always layin laws, lordin fuckin fuckin boys..fuck that I got that glock locked back! Givin you more what you hopin for! Ya, hopin in the lord, ya, you hoping in vein material supersticious shit, that's why you can't see me house nigga's ( ) state yo' name.",
  "You the devil!! AHAHA!!! You the devil!! You a satanist huh?!! So you a ey, ey...yee Then you wrote a book too, you got a book with blood on it huh! you satan huh! Who created your ass satan?! Who created your ass?!! I come in the name of Jesus by the power of the Holy Spirit",
  "The devil is a motherfuckin' liar, so you know I ain't worried, biotch! Stupid bitch.",
  "you satan huh! Who created your ass satan?! Who created your ass?!!",
  "Look at that, I'm provoking that, huh? I'm making motherfuckas just hate God more. I'm provoking that, huh? Haha, you goddamn Devil worshiper, you ain't got no excuse! Motherfucka, you ain-you ain't comin' in no-you come in the name of Satan. I guess if you, like, a house-nigga who wanna go competitive-if I say I'm God, then I guess you have to take the side of Satan, huh, motherfucka? Hmph... Stupid bitch.",
  "Look at that, I'm provoking that, huh? I'm making motherfuckas just hate God more.",
  "Not of-it's not of competition, it's of cooperation, stupid-ass house-nigga!"
  ]

module.exports = (robot) ->
  robot.hear /.*(preach).*/i, (msg) ->
    msg.send msg.random quotes