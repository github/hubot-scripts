# Description:
#   Play Cards Against Humanity in Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   q card - Returns a question
#   card me - Displays an answer
#   card 2 - Displays two answers for questions with two blanks
#
# Author:
#   Jonny Campbell (@jonnycampbell)

questions = [
  "____? There's a app for that.",
  "Why can't I sleep at night?",
  "What's that smell?",
  "I got 99 problems but _____ ain't one.",
  "Who stole the cookies from the cookie jar?",
  "What's the next Happy Meal toy?",
  "Anthropologists have recently discovered a primitive tribe that worships ____.",
  "It's a pity that kids these days are all getting involved with ____.",
  "During Picasso's often-overlooked Brown Period he produced hundreds of paintings of ____.",
  "Alternative medecine is now embracing the curative powers of ____.",
  "What's that sound?",
  "What ended my last relationship?",
  "MTV's new reality show features eight washed-up celebrities living with ____.",
  "I drink to forget ____.",
  "What is Batman's guilty pleasure?",
  "This is the way the worlds ends.  Not with a bang but with ____.",
  "What's a girl's best friend?",
  "TSA guidelines now prohibits ____ on airplanes.",
  "____. This is how I die.",
  "For my next trick I will pull ____ out of ____.",
  "In the new Disney Channel Original Movie Hannah Montana struggles with ____ for the first time.",
  "____ is a slippery slope that leads to ____.",
  "What does Dick Cheney prefer?",
  "I wish I hadn't lost the instruction manual for ____.",
  "Instead of coal Santa now gives the bad children ____.",
  "What's the most emo?",
  "In 1000 years, when paper money is but a distant memory, ____ will be our currency.",
  "What's the next superhero/sidekick duo? (Choose 2)",
  "In M. Night Shyamalan's new movie, Bruce Willis discovers that ____ had really been ___ all along.",
  "A romantic, candlelit dinner would be incomplete without ____.",
  "_____. Betcha can't have just one!",
  "White people like ____.",
  "____. High five, bro.",
  "Next from J.K. Rowling: Harry Potter and the Chamber of ____.",
  "In a world savaged by ____, our only solace is _____.",
  "War! What is it good for?",
  "During sex, I like to think about ____.",
  "What are my parents hiding from me?",
  "What will always get you laid?",
  "When I'm in prison, I'll have ____ smuggled in.",
  "What did I bring back from Mexico?",
  "What don't you want to find in your Chinese food?",
  "What will I bring back in time to convince people that I am a powerful wizard?",
  "How am I maintaining my relationship status?",
  "____. It's a trap!",
  "Coming to Broadway this season, ____.",
  "While the United States raced the Soviet Union to the moon, the Mexican government funneled millions of pesos into research on ____.",
  "After Hurricane Katrina, Sean Penn brought ____ to the people of New Orleans.",
  "Due to a PR fiasco, Tesco no longer offers ____.",
  "In his new summer comedy, Rob Schneider is ____ trapped in the body of ____.",
  "Rumor has it that Vladimir Putin's favorite dish is ____ stuffed with ____.",
  "But before I kill you, Mr Bond, I must show you ____.",
  "What gives me uncontrollable gas?",
  "What do old people smell like?",
  "The class field trip was completely ruined by ____.",
  "When Pharaoh remained unmoved, Moses called down a Plague of ____.",
  "What's my secret power?",
  "What's there a ton of in heaven?",
  "What would grandma find disturbing, yet oddly charming?",
  "I never truly understood ____ until I encountered ____.",
  "The US has begun airdropping ___ to the children of Afghanistan.",
  "What helps Obama unwind?",
  "What did Vin Diesel eat for dinner?",
  "____: Good to the last drop.",
  "Why am I sticky?",
  "What gets better with age?",
  "____: kid-tested.",
  "What's the crustiest?",
  "Studies show that lab rats navigate mazes 50% after being exposed to ____.",
  "Life was difficult for cavemen before _____.",
  "I do not know with what weapons World War III will be fought, but World War IV will be fought with ____.",
  "Why do I hurt all over?",
  "What am I giving up for Lent?",
  "In Michael Jackson's final moments, he thought about ____.",
  "In an attempt to reach a wider audience, the Smithsonian Museum of Natural History has opened an interactive exhibit on ____.",
  "When I am President of the United States, I will create the Department of ____.",
  "When I was tripping on acid, ____ turned into ____.",
  "That's right, I killed ____, How, you ask ? ____.",
  "What's my anti-drug?",
  "What never fails to liven up the party?",
  "What's the new fad diet?",
  "Major League Baseball has banned ____ for giving players an unfair advantage."
]

answers = [
  "Coat hanger abortions",
  "Man meat",
  "Autocannibalism",
  "Vigorous jazz hands",
  "Flightless birds",
  "Pictures of boobs",
  "Doing the right thing",
  "Hunting accidents",
  "A cartoon camel enjoying the smooth",
  "The violation of our most basic human rights",
  "Viagra",
  "Self-loathing",
  "Spectacular abs",
  "An honest cop with nothing left to lose",
  "Abstinence",
  "A balanced breakfast",
  "Mountain Dew Code Red",
  "Concealing a boner",
  "Roofies",
  "Tweeting",
  "The Big Bang",
  "Amputees",
  "Dr. Marting Luther King Jr",
  "Former President George W. Bush",
  "Being marginalized",
  "Smegma",
  "Laying an egg",
  "Cuddling",
  "Aaron Burr",
  "The Pope",
  "A bleached asshole",
  "Horse meat",
  "Genital piercings",
  "Fingering",
  "Elderly Japanese men",
  "Stranger danger",
  "Fear itself",
  "Science",
  "Praying the gay away",
  "Same-sex ice dancing",
  "The terrorists",
  "Making sex at her",
  "German dungeon porn",
  "Bingeing and purging",
  "Ethnic cleansing",
  "Cheating in the Special Olympics",
  "Nickelback",
  "Heteronormativity",
  "William Shatner",
  "Making a pouty face",
  "Chainsaws for hands",
  "The placenta",
  "The profoundly handicapped",
  "Tom Cruise",
  "Object permanence",
  "Goblins",
  "An icepick lobotomy",
  "Arnold Schwarzenegger",
  "Hormone injections",
  "A falcon with a cap on its head",
  "Foreskin",
  "Dying",
  "Stunt doubles",
  "The invisible hand",
  "Jew-fros",
  "A really cool hat",
  "Flash flooding",
  "Flavored condoms",
  "Dying of disentery",
  "Sexy pillow fights",
  "The Three-Fifths compromise",
  "A sad handjob",
  "Men",
  "Historically black colleges",
  "Sean Penn",
  "Heartwarming orphans",
  "Waterboarding",
  "The clitoris",
  "Vikings",
  "Friends who eat all the snacks",
  "The Underground Railroad",
  "Pretending to care",
  "Raptor attacks",
  "A micropenis",
  "A Gypsy curse",
  "Agriculture",
  "Bling",
  "A clandestine butt scratch",
  "The South",
  "Sniffing glue",
  "Consultants",
  "My humps",
  "Geese",
  "Being a dick to children",
  "Party poopers",
  "Sunshine and rainbows",
  "Mutually-assured destruction",
  "Heath Ledger",
  "Sexting",
  "An Oedipus complex",
  "Eating all of the cookies before the AIDS bake-sale",
  "A sausage festival",
  "Michael Jackson",
  "Skeletor",
  "Chivalry",
  "Sharing needles",
  "Being rich",
  "Spontaneous human combustion",
  "College",
  "Necrophilia",
  "The Chinese gymnastics team",
  "Global warming",
  "Farting and walking away",
  "Cookie Monster devouring the Eucharist wafers",
  "Stifling a giggle at the mention of Hutus and Tutsis",
  "Penis envy",
  "Letting yourself go",
  "White people",
  "Leaving an awkward voicemail",
  "Yeast",
  "Natural selection",
  "Masturbation",
  "Twinkies",
  "A LAN party",
  "Opposable thumbs",
  "A grande sugar-free iced soy caramel macchiato",
  "Soiling oneself",
  "A sassy black woman",
  "Sperm whales",
  "Teaching a robot to love",
  "Scrubbing under the folds",
  "A drive-by shooting",
  "Whipping it out",
  "Panda sex",
  "Catapults",
  "Will Smith",
  "Toni Morrison's vagina",
  "Five-Dollar Foot-longs",
  "Land mines",
  "A sea of troubles",
  "A zesty breakfast burrito",
  "Christopher Walken",
  "Friction",
  "Balls",
  "AIDS",
  "The KKK",
  "Gandhi",
  "Dave Matthews Band",
  "Preteens",
  "The token minority",
  "Friends with benefits",
  "Pixelated bukkake",
  "Substitute teachers",
  "Take-backsies",
  "A thermonuclear detonation",
  "Waiting 'til marriage",
  "A tiny horse",
  "A can of whoop-ass",
  "Dental dams",
  "Feeding Rosie O'Donnell",
  "Old-people smell",
  "Genghis Khan",
  "Authentic Mexican cuisine",
  "Oversized lollipops",
  "Garth Brooks",
  "Keanu Reeves",
  "Drinking alone",
  "The American Dream",
  "Taking off your shirt",
  "Giving 110%",
  "Flesh-eating bacteria",
  "Child abuse",
  "A cooler full of organs",
  "A moment of silence",
  "The Rapture",
  "Keeping Christ in Chrismas",
  "Robocop ",
  "That one gay Teletubby",
  "Sweet",
  "Fancy Feast",
  "Pooping back and forth. Forever.",
  "Being a motherfucking sorcerer",
  "Jewish fraternities",
  "Edible underpants",
  "Poor people",
  "All-you-can-eat shrimps for $4.99",
  "Britney Spears at 55",
  "That thing that electrocutes your abs",
  "The folly of man",
  "Fiery poops",
  "Cards Against Humanity",
  "A murder most foul",
  "Me time",
  "The inevitable heat death of the universe",
  "Nocturnal emissions",
  "Daddy issues",
  "The hardworking Mexican",
  "Natalie Portman",
  "Waking up half-naked in a McDonalds's parking lot",
  "Nipple blades",
  "Assless chaps",
  "Full frontal nudity",
  "Hulk Hogan",
  "Passive-aggression",
  "Ronald Reagan",
  "Vehicular manslaughter",
  "Menstruation",
  "Pulling out",
  "Picking up girls at the abortion clinic",
  "The homosexual agenda",
  "The Holy Bible",
  "World peace",
  "Dropping a chandelier on your enemies and riding the rope up",
  "Testicular torsion",
  "The milk man",
  "A time-travel paradox",
  "Hot Pockets",
  "Guys who don't call",
  "Eating the last known bison",
  "Darth Vader",
  "Scalping",
  "Homeless people",
  "The Worlds of Warcraft",
  "Gloryholes",
  "Saxophone solos",
  "Sean Connery",
  "God",
  "Intelligent design",
  "The taint",
  "Friendly fire",
  "Keg stands",
  "Eugenics",
  "A good sniff",
  "Lockjaw",
  "A neglected Tamagotchi",
  "The People's Elbow",
  "Robert Downey Jr.",
  "The heart of a child",
  "Seduction",
  "Smallpox blankets",
  "Licking things to claim them as your own",
  "A salty surprise",
  "Poorly-timed Holocaust jokes",
  "My soul",
  "My sex life",
  "Pterodactyl eggs",
  "Altar boys",
  "Forgetting the Alamo",
  "72 virgins",
  "Raping and pillaging",
  "Pedophiles",
  "Eastern European Turbo-Folk music",
  "A snapping turtle biting the tip of your penis",
  "Domino's Oreo Dessert Pizza",
  "My collection of high-tech sex toys",
  "A middle-aged man on roller skates",
  "The Blood of Christ",
  "Half-assed foreplay",
  "Free samples",
  "Douchebags on their iPhones",
  "Hurricane Katrina",
  "Wearing underwear inside-out to avoid doing laundry",
  "Republicans",
  "The glass ceiling",
  "A foul mouth",
  "Jerking off into a pool of children's tears",
  "Getting really high",
  "The deformed",
  "Michelle Obama's arms",
  "Explosions",
  "The Übermensch",
  "Donald Trump",
  "Sarah Palin",
  "Attitude",
  "This answer is postmodern",
  "Crumpets with the Queen",
  "Frolocking",
  "Team-building exercises",
  "Repression",
  "Road head",
  "A bag of magic beans",
  "An asymmetric boob job",
  "Dead parents",
  "Public ridicule",
  "A mating display",
  "A mime having a stroke",
  "Stephen Hawking talking dirty",
  "African Children",
  "Mouth herpes",
  "Overcompensation",
  "Bill Nye the Science Guy",
  "Bitches",
  "Italians",
  "Have some more kugel",
  "A windmill full of corpses",
  "Her Royal Highness",
  "Crippling debt",
  "Adderall",
  "A stray pube",
  "Shorties and blunts",
  "Passing a kidney stone",
  "Prancing",
  "Leprosy",
  "A brain tumor",
  "Bees ?",
  "Puppies !",
  "Cockfights",
  "Kim Jong-Il",
  "Hope",
  "9oz. of sweet Mexican black-tar heroin",
  "Incest",
  "Grave robbing",
  "Asians who aren't good at math",
  "Alcoholism",
  "(I am doing Kegels right now.)",
  "Justin Bieber",
  "The Jews",
  "Bestiality",
  "Winking at old people",
  "Drum circles",
  "Kids with ass cancer",
  "Loose lips",
  "Auschwitz",
  "Civilian casualties",
  "Inappropriate yodeling",
  "Tangled Slinkys",
  "Being on fire",
  "The Thong Song",
  "A vajazzled vagina",
  "Riding off into the sunset",
  "Exchanging pleasantries",
  "My relationship status",
  "Being fabulous",
  "Lactation",
  "Not reciprocating oral sex",
  "Sobbing into a Hungry-Man Frozen Dinner",
  "My genitals",
  "Date rape",
  "Ring Pops",
  "GoGurt",
  "Judge Judy",
  "Lumberjack fantasies",
  "The gays",
  "Scientology",
  "Estrogen",
  "Police brutality",
  "Passable transvestites",
  "The Virginia Tech Massacre",
  "Tiger Woods",
  "Dick Fingers",
  "Racism",
  "Glenn Beck being harried by a swarm of buzzards",
  "Surprise sex!",
  "Classist undertones",
  "Booby-trapping the house to foil burglars",
  "New Age music",
  "PCP",
  "A lifetime of sadness",
  "Doin't it in the butt",
  "Swooping",
  "The Hamburglar",
  "Tentacle porn",
  "A hot mess",
  "Too much hair gel",
  "A look-see",
  "Not giving a shit about the Third World",
  "American Gladiators",
  "The Kool-Aid Man",
  "Mr. Snuffleupagus",
  "Barack Obama",
  "Golden showers",
  "Wiping her butt",
  "Queefing",
  "Getting drunk on mouthwash",
  "A M. Night Shyamalan plot twist",
  "A robust mongoloid",
  "Nazis",
  "White privilege",
  "An erection that lasts longer than four hours",
  "A disappointing birthday party",
  "Puberty",
  "Two midgets shitting into a bucket",
  "Wifely duties",
  "The forbidden fruit",
  "Getting so angry that you pop a boner",
  "Sexual tension",
  "Third base",
  "A gassy antelope",
  "Those times when you get sand in your vagina",
  "A Super Soaker full of cat pee",
  "Muhammad (Praise Be Unto Him)",
  "Racially-biased SAT questions",
  "Porn stars",
  "A fetus",
  "Obesity",
  "When you fart and a little bit comes out",
  "Oompa-Loompas",
  "BATMAN!!!",
  "Black people",
  "Tasteful sideboob",
  "Hot people",
  "Grandma",
  "Cooping a feel",
  "The Trail of Tears",
  "Famine",
  "Finger painting",
  "The miracle of childbirth",
  "Goats eating cans",
  "A monkey smoking a cigar",
  "Faith healing",
  "Parting the Red Sea",
  "Dead babies",
  "The Amish",
  "Impotence",
  "Child beauty pageants",
  "Centaurs",
  "AXE Body Spray",
  "Kanye West",
  "Women's suffrage",
  "Children on leashes",
  "Harry Potter erotica",
  "The Dance of the Sugar Plum Fairy",
  "Lance Armstrong's missing testicle",
  "Dwarf tossing",
  "Mathletes",
  "Lunchables",
  "Women in yogurt commercials",
  "John Wilkes Booth",
  "Powerful thighs",
  "Mr Clean",
  "Multiple stab wounds",
  "Cybernetic enhancements",
  "Serfdom",
  "Another goddamn vampire movie",
  "Glenn Beck catching his scrotum on a curtain hook",
  "A big hoopla about nothing",
  "Peeing a little bit",
  "The Hustle",
  "Ghosts",
  "Bananas in Pajamas",
  "Active listening",
  "Dry heaving",
  "Kamikaze pilots",
  "The Force",
  "Anal beads",
  "The Make-A-Wish Foundation"
]

module.exports = (robot) ->
  robot.respond /card(?: me)?(?: )(\d+)?/i, (msg) ->
    count = if msg.match[1]? then parseInt(msg.match[1], 10) else 1
    msg.send msg.random answers for i in [1..count]

  robot.respond /q(?:uestion)? card/i, (msg) ->
    msg.send msg.random questions
