module.exports = (robot) ->
	robot.hear /^yoda quote$/i, (msg) ->
		quotes = ["Agree with you, the council does. Your apprentice, Skywalker will be.",
		"Always two there are, no more, no less: a master and an apprentice.",
		"Fear is the path to the Dark Side. Fear leads to anger, anger leads to hate; hate leads to suffering. I sense much fear in you.",
		"Qui-Gon's defiance I sense in you.",
		"Truly wonderful the mind of a child is.",
		"Around the survivors a perimeter create.",
		"Lost a planet Master Obi-Wan has. How embarrassing … how embarrassing.",
		"Victory, you say? Master Obi-Wan, not victory. The shroud of the Dark Side has fallen. Begun the Clone War has.",
		"Much to learn you still have...my old padawan... This is just the beginning!",
		"Twisted by the Dark Side young Skywalker has become.",
		"The boy you trained, gone he is, consumed by Darth Vader.",
		"Death is a natural part of life. Rejoice for those around you who transform into the Force. Mourn them do not. Miss them do not. Attachment leads to jealousy. The shadow of greed that is. Train yourself to let go of everything you fear to lose.",
		"The fear of loss is a path to the Dark Side.",
		"If into the security recordings you go, only pain will you find.",
		"Not if anything to say about it I have.",
		"Great warrior, hmm? Wars not make one great.",
		"Do or do not; there is no try.",
		"Size matters not. Look at me. Judge me by my size, do you?",
		"That is why you fail.",
		"No! No different. Only different in your mind. You must unlearn what you have learned.",
		"Always in motion the future is.",
		"Reckless he is. Matters are worse.",
		"When nine hundred years old you reach, look as good, you will not.",
		"No. There is... another... Sky... walker..."]
		msg.send msg.random quotes
		