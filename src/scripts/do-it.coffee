# Description:
#   Ask hubot how people do it.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot how do <group/occupation> do it? -- tells you how they do it (e.g. hubot how do hackers do it?)
#   hubot <people> do it <method> -- tells hubot how <people> do it (e.g. hubot GitHubbers do it in Campfire.)
#   hubot do it -- tells you a random way in which random people do it
#
# Notes:
#   Node.js programmers do it asynchronously.
#   List taken from http://www.dkgoodman.com/doita-f.html#top and originally compiled by Chris Morton.
#
# Author:
#   jenrzzz


String.prototype.capitalize ||= -> @.charAt(0).toUpperCase() + @.slice(1)

module.exports = (robot) ->
  unless robot.brain.do_it?.grouped_responses?
    do_it_responses = DO_IT.split('\n')
    robot.brain.do_it =
      responses: do_it_responses
      grouped_responses: compile_list(do_it_responses)

  robot.respond /do it$/i, (msg) ->
    msg.send msg.random(robot.brain.do_it.responses)

  robot.respond /how (?:do|does) (.+) do it\??/i, (msg) ->
    group = msg.match[1].toLowerCase().trim()
    if robot.brain.do_it.grouped_responses[group]?
      msg.send msg.random robot.brain.do_it.grouped_responses[group]
    else
      msg.send "Hmmm, I'm not sure how they do it."

  robot.respond /(.+) (?:do|does) it (?:.+)/i, (msg) ->
    group = msg.match[1].toLowerCase().trim()
    robot.brain.do_it.responses.push msg.match[0]
    robot.brain.do_it.grouped_responses[group] ||= []
    robot.brain.do_it.grouped_responses[group].push msg.match[0].slice(msg.match[0].indexOf(' ') + 1).capitalize()

compile_list = (responses) ->
  grouped = {}
  responses.forEach (r) ->
    if /do it/.test(r)
      group_name = r.slice(0, r.indexOf('do it')).toLowerCase().trim()
    else
      group_name = r.slice(0, r.indexOf(' ')).toLowerCase().trim()

    grouped[group_name] ||= []
    grouped[group_name].push r
  return grouped

DO_IT = '''A king does it with his official seal.
Accountants are good with figures.
Accountants do it for profit.
Accountants do it with balance.
Accountants do it with double entry.
Accy majors do it in numbers.
Acrophobes get down.
Actors do it in the limelight.
Actors do it on camera.
Actors do it on cue.
Actors do it on stage.
Actors play around.
Actors pretend doing it.
Actuaries probably do it
Actuaries do it continuously and discretely.
Actuaries do it with varying rates of interest.
Actuaries do it with models.
Actuaries do it on tables.
Actuaries do it with frequency and severity.
Actuaries do it until death or disability, whichever comes first.
Acupuncturists do it with a small prick.
Ada programmers do it by committee.
Ada programmers do it in packages.
Advertisers use the "new, improved" method.
Advertising majors do it with style.
Aerobics instructors do it until it hurts.
Aerospace engineers do it with lift and thrust.
Agents do it undercover.
AI hackers do it artificially.
AI hackers do it breast first.
AI hackers do it depth first.
AI hackers do it robotically.
AI hackers do it with robots.
AI hackers do it with rules.
AI hackers make a big production out of it.
AI people do it with a lisp.
Air couriers do it all over the world in big jets.
Air traffic controllers do it by radar.
Air traffic controllers do it in the dark.
Air traffic controllers do it with their tongue.
Air traffic controllers tell pilots how to do it.
Air traffic, getting things down safely.
Airlifters penetrate further, linger longer, and drop a bigger load.
Airline pilots do it at incredible heights.
Alexander Portnoy does it alone.
Algebraists do it with homomorphisms.
Algorithmic analysts do it with a combinatorial explosion.
Alpinists do it higher.
Alvin Toffler will do it in the future.
AM disc jockeys do it with modulated amplitude.
Amateur radio operators do it with frequency.
Ambulance drivers come quicker.
America finds it at Waldenbooks.
Anaesthetists do it until you fall asleep.
Analog hackers do it continuously.
Anarchists do it revoltingly.
Anesthetists do it painlessly.
Anglers do it with worms.
Animators do it 24 times a second.
Announcers broadcast.
ANSI does it in the standard way.
Anthropologists do it with culture.
APL programmers are functional.
APL programmers do it backwards.
APL programmers do it in a line.
APL programmers do it in the workspace.
APL programmers do it with stile.
Apologists do it orally.
Archaeologists do it in the dirt.
Archaeologists do it with mummies.
Archaeologists like it old.
Archers use longer shafts.
Architects are responsible for the tallest erections.
Architects do it late.
Architects have great plans.
Architectural historians can tell you who put it up and how big it was.
Architecture majors stay up all night.
Arlo Guthrie does it on his motorcycle.
Arsonists do it with fire.
Art historians can tell you who did it, where they did it, what they.
Artillerymen do it with a burst.
Artists are exhibitionists.
Artists do it by design.
Artists do it in the buff.
Artists do it with creativity.
Artists do it with emotion.
Assassins do it from behind.
Assembly line workers do it over and over.
Assembly programmers do it a byte at a time.
Assembly programmers only get a little bit to play with.
Astronauts do it in orbit.
Astronauts do it on re-entry.
Astronauts do it on the moon.
Astronomers can't do it with the lights on.
Astronomers do it all night.
Astronomers do it from light-years away.
Astronomers do it in the dark.
Astronomers do it only at night.
Astronomers do it under the stars.
Astronomers do it whenever they can find a hole in the clouds.
Astronomers do it while gazing at Uranus.
Astronomers do it with all the stars.
Astronomers do it with a big bang.
Astronomers do it with heavenly bodies.
Astronomers do it with long tubes.
Astronomers do it with stars.
Astronomers do it with their telescopes.
Astronomers do it with Uranus.
Astrophysicists do it with a big bang.
AT&T does it in long lines.
Attorneys make better motions.
Auditors like to examine figures.
Australians do it down under.
Authors do it by rote.
Auto makers do it with optional equipment.
Auto makers do it with standard equipment.
Auto mechanics do it under hoods, using oil and grease.
Babies do it in their pants.
Babysitters charge by the hour.
Bach did it with the organ.
Bailiffs always come to order.
Bakers do it for the dough.
Bakers knead it daily.
Ballerinas do it en point.
Ballet dancers do it on tip-toe.
Ballet dancers do it with toes.
Banana pickers do it in bunches.
Band members do it all night.
Band members do it in a parade.
Band members do it in front of 100,000 people.
Band members do it in public.
Band members do it in sectionals.
Band members do it on the football field.
Band members play all night.
Banjo players pluck with a stiff pick.
Bank tellers do it with interest. Penalty for early withdrawl.
Bankers do it for money, but there is a penalty for early withdrawal.
Bankers do it with interest, but pay for early withdrawl.
Baptists do it under water.
Barbarians do it with anything.  (So do orcs.)
Barbers do it and end up with soaping hair.
Barbers do it with Brylcreem.
Barbers do it with shear pleasure.
Bartenders do it on the rocks.
Baseball players do it for a lot of money.
Baseball players do it in teams.
Baseball players do it with their bats.
Baseball players hit more home runs.
Baseball players make it to first base.
Basic programmers do it all over the place.
Basic programmers goto it.
Basketball players score more often.
Bass players just pluck at it.
Bassists do it with their fingers.
Batman does it with Robin.
Bayseians probably do it.
Beekeepers like to eat their honey.
Beer brewers do it with more hops.
Beer drinkers get more head.
Beethoven did it apassionately.
Beethoven was the first to do it with a full orchestra.
Bell labs programmers do it with Unix.
Bell-ringers pull it themselves.
Beta testers do it looking for mistakes.
Bicyclists do it with 10 speeds.
Biologists do it with clones.
Birds do it, bees do it, even chimpanzees do it.
Blind people do it in the dark.
Bloggers do it with comments.
Blondes do it with a Thermos.
Bo Jackson knows doing it.
Boardheads do it with stiff masts.
Body-builders do it with muscle.
Bookkeepers are well balanced.
Bookkeepers do it for the record.
Bookkeepers do it with double entry.
Bookworms only read about it.
Bosses delegate the task to others.
Bowlers do it in the alley.
Bowlers have bigger balls.
Boxers do it with fists.
Boy scouts do it in the woods.
Bricklayers lay all day.
Bridge players do it with finesse.
Bridge players try to get a rubber.
Buddhists imagine doing it.
Building inspectors do it under the table.
Bulimics do it after every meal.
Burglars do it without protection.
Bus drivers come early and pull out on time.
Bus drivers do it in transit.
Businessmen screw you the best they can.
Butchers have better meat.
C programmers continue it.
C programmers switch and then break it.
C programmers switch often.
C++ programmers do it with class.
C++ programmers do it with private members and public objects.
C++ programmers do it with their friends, in private.
Calculus majors do it in increments.
Calculus students do it by parts.
Californians do it laid back.
Campers do it in a tent.
Car customisers do it with a hot rod.
Car mechanics jack it.
Cardiologists do it halfheartedly.
Carpenters do it tongue in groove.
Carpenters hammer it harder.
Carpenters nail harder.
Carpet fitters do it on their knees.
Carpet layers do it on the floor.
Cartoonists do it with just a few good strokes.
Catholics do it a lot.
Catholics talk about it afterwards.
Cavaliers do it mounted.
Cavers do it in the mud.
CB'ers do it on the air.
Cellists give better hand jobs.
Cheerleaders do it enthusiastically.
Cheerleaders do it with more enthusiasm.
Chefs do it for dessert.
Chefs do it in the kitchen.
Chemical engineers do it in packed beds.
Chemical engineers do it under a fume hood.
Chemists do it in an excited state.
Chemists do it in test tubes.
Chemists do it in the fume hood.
Chemists do it periodically on table.
Chemists do it reactively.
Chemists like to experiment.
Chess players check their mates.
Chess players do it in their minds.
Chess players do it with knights/kings/queens/bishops/mates.
Chess players mate better.
Chessplayers check their mates.
Chiropractors do it by manipulation.
Chiropractors do it, but they x-ray it first.
Choir boys do it unaccompanied.
Circuit designers have a very low rise time.
City planners do it with their eyes shut.
City street repairmen do it with three supervisors watching.
Civil engineers do it by reinforcing it.
Civil engineers do it in the dirt.
Civil engineers do it with an erection.
Clerics do it with their gods.
Climbers do it on rope.
Clinton does it with flowers.
Clock makers do it mechanically.
Clowns do it for laughs.
Cluster analysts do it in groups.
Coaches whistle while they work.
Cobol hackers do it by committee.
Cobol programmers are self-documenting.
Cobol programmers do it very slowly.
Cobol programmers do it with bugs.
Cockroaches have done it for millions of years, without apparent ill-effects.
Cocktail waitresses serve highballs.
Collectors do it in sets.
Colonel Sanders does it, then licks his fingers.
Comedians do it for laughs.
Commodities traders do it in the pits.
Communications engineers do it 'til it hertz.
Communists do it without class.
Compiler writers optimize it, but they never get around to doing it.
Complexity freaks do it with minimum space.
Composers do it by numbers.
Composers do it with a quill and a staff.
Composers do it with entire orchestras.
Composers leave it unfinished.
Computer engineers do it with minimum delay.
Computer game players just can't stop.
Computer nerds just simulate it.
Computer operators do it upon mount requests.
Computer operators do it with hard drives.
Computer operators get the most out of their software.
Computer operators peek before they poke.
Computer programmers do it bit by bit.
Computer programmers do it interactively.
Computer programmers do it logically.
Computer programmers do it one byte at a time.
Computer science students do it with hard drives.
Computer scientists do it bit by bit.
Computer scientists do it on command.
Computer scientists simulate doing it.
Computers do it in ascii, except ibm's which use ebcdic.
Conductors do it rhythmically.
Conductors do it with the orchestras.
Conductors wave it up and down.
Confectioners do it sweetly.
Congregationalists do it in groups.
Congressmen do it in the house.
Construction workers do it higher.
Construction workers lay a better foundation.
Consultants tell others how to do it.
Cooks do it with grease and a lot of heat.
Cooks do it with oil, sugar and salt.
Copier repairmen do it with duplicity.
Cops do it arrestingly.
Cops do it at gun-point.
Cops do it by the book.
Cops do it with cuffs.
Cops do it with electric rods.
Cops do it with nightsticks.
Cops have bigger guns.
Cowboys handle anything horny.
Cowgirls like to ride bareback.
Cows do it in leather.
Crane operators have swinging balls.
Credit managers always collect.
Cross-word players do it crossly.
Cross-word players do it horizontally and vertically.
Crosscountry runners do it in open fields.
Cryonicists stay stiff longer.
Cryptographers do it secretly.
Cuckoos do it by proxy.Dan quayle does it in the dark.
Dan quayle does it with a potatoe [sic].
Dancers do it in leaps and bounds.
Dancers do it to music.
Dancers do it with grace.
Dancers do it with their high heels on.
Dark horses do it come-from-behind.
Data processors do it in batches.
DB people do it with persistence.
Deadheads do it with Jerry.
Debaters do it in their briefs.
Deep-sea divers do it under extreme pressure.
Deer hunters will do anything for a buck.
Delivery men do it at the rear entrance.
Democratic presidential candidates do it and make you pay for it later.
Democratic presidential candidates do it underwater.
Democratic presidential candidates do it until they can't remember.
Demonstraters do it on the street.
Dental hygenists do it till it hurts.
Dentists do it in your mouth.
Dentists do it orally.
Dentists do it prophylactically.
Dentists do it with drills and on chairs.
Dentists do it with filling.
Deprogrammers do it with sects.
Detectives do it under cover.
Didgeridoo players do it with big sticks.
Didgeridoo players do it with hollow logs.
Dieticians eat better.
Digital hackers do it off and on.
Direct mailers get it in the sack.
Discover gives you cash back.
Dispatchers do it with frequency.
Ditch diggers do it in a damp hole.
Divers always do it with buddies.
Divers always use rubbers.
Divers bring flashlights to see better down there.
Divers can stay down there for a long time.
Divers do it deeper.
Divers do it for a score.
Divers do it in an hour.
Divers do it under pressure.
Divers do it underwater.
Divers do it with a twist.
Divers explore crevices.
Divers go down all the time.
Divers go down for hidden treasures.
Divers have a license to do it.
Divers like groping in the dark.
Divers like to take pictures down there.
Divers train to do it.
DJs do it on request.
DJs do it on the air.
Doctors do it in the O.R.
Doctors do it with injection.
Doctors do it with patience.
Doctors do it with pills.
Doctors do it with stethoscopes.
Doctors take two aspirins and do it in the morning.
Domino's does it in 30 minutes or less.
Don't do it with a banker.  Most of them are tellers.
Donors do it for life.
Drama students do it with an audience.
Drivers do it with their cars.
Druggists fill your prescription.
Druids do it in the bushes.
Druids do it with animals.
Druids leave no trace.
Drummers always have hard sticks.
Drummers beat it.
Drummers do it in 4/4 time.
Drummers do it longer.
Drummers do it louder.
Drummers do it with a better beat.
Drummers do it with both hands and feet.
Drummers do it with great rhythm.
Drummers do it with rhythm.
Drummers do it with their wrists.
Drummers have faster hands.
Drummers pound it.
Drywallers are better bangers.
Dungeon masters do it any way they feel like.
Dungeon masters do it anywhere they damn well please.
Dungeon masters do it behind a screen.
Dungeon masters do it in ways contrary to the laws of physics.
Dungeon masters do it to you real good.
Dungeon masters do it whether you like it or not.
Dungeon masters do it with dice.
Dungeon masters have better encounters.
Dyslexic particle physicists do it with hadrons.
E. E. Cumming does it with ease.
Economists do it at bliss point.
Economists do it cyclically.
Economists do it in an edgeworth box.
Economists do it on demand.
Economists do it with a dual.
Economists do it with an atomistic competitor.
Economists do it with interest.
Ee cummings does it with ease.
El ed majors teach it by example.
Electrical education majors teach it by example.
Electrical engineers are shocked when they do it.
Electrical engineers do it on an impulse.
Electrical engineers do it with faster rise time.
Electrical engineers do it with large capacities.
Electrical engineers do it with more frequency and less resistance.
Electrical engineers do it with more power and at higher frequency.
Electrical engineers do it with super position.
Electrical engineers do it without shorts.
Electrical engineers resonate until it hertz.
Electrician undo your shorts for you.
Electricians are qualified to remove your shorts.
Electricians check your shorts.
Electricians do it in their shorts.
Electricians do it just to plug it in.
Electricians do it until it hertz.
Electricians do it with 'no shorts'.
Electricians do it with spark.
Electrochemists have greater potential.
Electron microscopists do it 100,000 times.
Elevator men do it up and down.
Elves do it in fairy rings.
Employers do it to employees.
EMT's do it in ambulances.
Energizer bunny keeps going, and going, and going . . .
Engineers are erectionist perfectionists.
Engineers charge by the hour.
Engineers do it any way they can.
Engineers do it at calculated angles.
Engineers do it in practice.
Engineers do it precisely.
Engineers do it roughly.
Engineers do it to a first order approximation.
Engineers do it with less energy and greater efficiency.
Engineers do it with precision.
Engineers simply neglect it.
English majors do it with an accent.
English majors do it with style.
Entomologists do it with insects.
Entrepreneurs do it with creativity and originality.
Entymologists do it with bugs.
Evangelists do it with Him watching.
Evolutionary biologists do it with increasing complexity.
Executives do it in briefs.
Executives do it in three piece suits.
Executives have large staffs.
Existentialists do it alone.
F.B.I. does it under cover.
Factor analysts rotate their principal components.
Faith healers do it with whatever they can lay their hands on.
Fan makers are the best blowers in the business.
Fantasy roleplayers do it all night.
Fantasy roleplayers do it all weekend.
Fantasy roleplayers do it in a dungeon.
Fantasy roleplayers do it in a group.
Farmers do it all over the countryside.
Farmers do it in the dirt.
Farmers do it on a corn field.
Farmers plant it deep.
Farmers spread it around.
Fed-Ex agents will absolutely, positively do it overnight.
Fencers do it in a full lunge.
Fencers do it with a thrust.
Fencers do it with three feet of sword.
Fetuses do it in-vitro.
Firemen are always in heat.
Firemen do it wearing rubber.
Firemen do it with a big hose.
Firemen find `em hot, and leave `em wet.
Fishermen are proud of their rods.
Fishermen do it for reel.
Flagpole sitters do it in the air.
Flautists blow crosswise.
Flyers do it in the air.
Flyers do it on top, upside down, or rolling.
FM disc jockeys do it in stereo and with high fidelity.
Football players are measured by the yard.
Football players do it offensively/defensively.
Foresters do it in trees.
Forgers do it hot.
Formula one racers come too fast and in laps.
Forth programmers do it from behind.
Fortran programmers do it with double precision.
Fortran programmers do it with soap.
Fortran programmers just do it.
Four-wheelers eat more bush.
Frank Sinatra does it his way.
Fraternity men do it with their little sisters.
Frustrated hackers use self-modifying infinite perversion.
Furriers appreciate good beaver.
Fuzzy theorists both do it and don't do it.
Gamblers do it on a hunch.
Garbagemen come once a week.
Gardeners do it by trimming your bush.
Gardeners do it in bed.
Gardeners do it on the bushes.
Gardeners do it twice a year and then mulch it.
Gardeners have 50 foot hoses.
Gas station attendants pump all day.
Geeks do it in front of Windows.
Generals have something to do with the stars.
Genetecists do it with sick genes.
Geographers do it around the world.
Geographers do it everywhere.
Geographers do it globally.
Geologists are great explorers.
Geologists do it eruptively, with glow, and always smoke afterwards.
Geologists do it in folded beds.
Geologists do it to get their rocks off.
Geologists know how to make the bedrock.
Geometers do it constructively.
Gerald Ford does it on his face.
Gnomes are too short to do it.
Gnu programmers do it for free and they don't give a damn about look & feel.
Golfers always sink their putts.
Golfers do it in 18 holes.
Golfers do it with long shafts.
Golfers hit their balls with shafts.
Graduates do it by degrees.
Gravediggers die to do it.
Greeks do it with their brothers and sisters.
Guitar players do it with a g-string.
Guitar players had their licks.
Guitar players have their pick.
Guitarists strum it with their pick.
Gymnasts do it with grace.
Gymnasts mount and dismount well.
Gynecologists mostly sniff, watch and finger.
Hackers appreciate virtual dresses.
Hackers are I/O experts.
Hackers avoid deadly embrace.
Hackers discover the powers of two.
Hackers do it a little bit.
Hackers do it absolutely.
Hackers do it all night.
Hackers do it at link time.
Hackers do it attached.
Hackers do it automatically.
Hackers do it bottom up.
Hackers do it bug-free.
Hackers do it by the numbers.
Hackers do it concurrently.
Hackers do it conditionally.
Hackers do it detached.
Hackers do it digitally.
Hackers do it discretely.
Hackers do it during downtime.
Hackers do it during PM.
Hackers do it efficiently.
Hackers do it faster.
Hackers do it forever even when they're not supposed to.
Hackers do it globally.
Hackers do it graphically.
Hackers do it immediately.
Hackers do it in batches.
Hackers do it in dumps.
Hackers do it in less space.
Hackers do it in libraries.
Hackers do it in loops.
Hackers do it in parallel.
Hackers do it in stacks.
Hackers do it in the microcode.
Hackers do it in the software.
Hackers do it in trees.
Hackers do it in two states.
Hackers do it indirectly.
Hackers do it interactively.
Hackers do it iteratively.
Hackers do it loaded.
Hackers do it locally.
Hackers do it randomly.
Hackers do it recursively.
Hackers do it reentrantly.
Hackers do it relocatably.
Hackers do it sequentially.
Hackers do it synchronously.
Hackers do it top down.
Hackers do it with all sorts of characters.
Hackers do it with bugs.
Hackers do it with computers.
Hackers do it with daemons.
Hackers do it with DDT.
Hackers do it with demons.
Hackers do it with editors.
Hackers do it with fewer instructions.
Hackers do it with high priority.
Hackers do it with insertion sorts.
Hackers do it with interrupts.
Hackers do it with key strokes.
Hackers do it with open windows.
Hackers do it with phantoms.
Hackers do it with quick sorts.
Hackers do it with recursive descent.
Hackers do it with side effects.
Hackers do it with simultaneous access.
Hackers do it with slaves.
Hackers do it with their fingers.
Hackers do it with words.
Hackers do it without a net.
Hackers do it without arguments.
Hackers do it without detaching.
Hackers do it without proof of termination.
Hackers do it without protection.
Hackers do it without you even knowing it.
Hackers don't do it -- they're hacking all the time.
Hackers get off on tight loops.
Hackers get overlaid.
Hackers have better software tools.
Hackers have faster access routines.
Hackers have good hardware.
Hackers have high bawd rates.
Hackers have it where it counts.
Hackers have response time.
Hackers know all the right movs.
Hackers know what to diddle.
Hackers make it quick.
Hackers multiply with stars.
Hackers stay logged in longer.
Hackers stay up longer.
Hackers take big bytes.
Hair stylists are shear pleasure.
Hairdressers give the best blow jobs.
Ham operators do it with frequency.
Ham radio operators do it till their gigahertz.
Ham radio operators do it with higher frequency.
Ham radio operators do it with more frequency.
Handymen do it with whatever is available.
Handymen like good screws.
Hang-gliders do it in the air.
Hardware buffs do it in nanoseconds.
Hardware designers' performance is hardware dependant.
Hardware hackers are a charge.
Hardware hackers do it closely coupled.
Hardware hackers do it electrically.
Hardware hackers do it intermittently.
Hardware hackers do it noisily.
Hardware hackers do it on a bus.
Hardware hackers do it over a wide temperature range.
Hardware hackers do it with AC and DC.
Hardware hackers do it with bus drivers.
Hardware hackers do it with charge.
Hardware hackers do it with connections.
Hardware hackers do it with emitter-coupled logic.
Hardware hackers do it with female banana plugs.
Hardware hackers do it with male connectors.
Hardware hackers do it with maximum ratings.
Hardware hackers do it with power.
Hardware hackers do it with resistance.
Hardware hackers do it with transceivers.
Hardware hackers do it with uncommon emitters into open collectors.
Hardware hackers have faster rise times.
Hardware hackers have sensitive probes.
Harpists do it by pulling strings.
Hawaiians do it volcanicly.
Hedgehogs do it cautiously.
Heinz does it with great relish.
Heisenberg might have done it.
Helicopter pilots do it while hovering.
Helicopter pilots do it with autorotation.
Hermits do it alone.
Hewlett packard does it with precision.
Hikers do it naturally.
Historians did it.
Historians do it for old times' sake.
Historians do it for prosperity.
Historians do it over long periods of time.
Historians study who did it.
Hobbits do it only if it isn't dangerous.
Hockey-players do it; so what?.
Horn players do it French style.
Horseback riders stay in the saddle longer.
Hunters do it in the bush.
Hunters do it with a bang.
Hunters do it with a big gun.
Hunters eat what they shoot.
Hunters go deeper into the bush.
Hurdlers do it every 10 meters.
Hydrogeologists do it till they're all wet.
Hypertrichologists do it with intensity.
I do it, but nobody else is ever there... so nobody believes me.
I just do it.
I/O hackers do it without interrupt.
I/O hackers have to condition their device first.
Illusionists fake it.
Illusionists only look like they're doing it.
Individualist does it with himself.
Inductors dissipate after doing it.
Infantrymen do it in the trench.
Infectious disease researchers do it with breeding and culture.
Information theorists analyze it with wiener filters.
Insurance salesmen are premium lovers.
Interior decorators do it all over the house.
Interpreters do it manually and orally.
Introverts do it alone.
Inventors find a way to do it.
Irs does it everywhere.
Irs does it to everyone.
Italians do it better.  (This line was obviously written by an Italian).
Janitors clean up afterwards.
Janitors do it with a plunger.
Jedi knights do it forcefully.
Jedi masters do it with even more force.
Jewelers mount real gems.
Jews worry about doing it.
Jockeys do it at the gate.
Jockeys do it on the horse-back.
Jockeys do it with their horses.
Jockeys do it with whips and saddles.
Joggers do it on the run.
Judges do it in chambers.
Judges watch it and give scores.
Jugglers do it in a flash.
Jugglers do it with more balls.
Jugglers do it with their balls in the air.
Kayakers do it, roll over, and do it again.
Keyboardists use all their fingers.
Keyboardists use both their hands on one organ.
Landlords do it every month.
Landscapers plant it deeper.
Laser printers do it without making an impression.
Lawyers do it in their briefs.
Lawyers do it on a table.
Lawyers do it on a trial basis.
Lawyers do it to you.
Lawyers do it with clause.
Lawyers do it with extensions in their briefs.
Lawyers do it, which is a great pity.
Lawyers lie about doing it and charge you for believing them.
Lawyers would do it but for 'hung jury'.
Left handers do it right.
Let a gardener trim your bush today.
Let an electrician undo your shorts for you.
Librarians do it by the book.
Librarians do it in the stacks.
Librarians do it on the shelfs.
Librarians do it quietly.
Lifeguards do it on the beach.
Linguists do it with their tongues.
Lions do it with pride.
Lisp hackers are thweet.
Lisp hackers do it in lambda functions.
Lisp hackers do it with rplacd.
Lisp programmers do it by recursion.
Lisp programmers do it without unexpected side effects.
Lisp programmers have to stop and collect garbage.
Locksmiths can get into anything.
Logic programmers do it with unification/resolution.
Logicians do it consistently and completely.
Logicians do it or they do not do it.
Long distance runners last longer.
Long jumpers do it with a running start.
Long-distance runners do it on a predetermined route.
Luddites do it with their hands.
Mac programmers do it in windows.
Mac users do it with mice.
Machine coders do it in bytes.
Machine language programmers do it very fast.
Machinists do it with screw drivers.
Machinists drill often.
Machinists make the best screws.
MacIntosh programmers do it in Windows.
Mages do it with their familiars.
Magic users do it with their hands.
Magic users have crystal balls.
Magicians are quicker than the eye.
Magicians do it with mirrors.
Magicians do it with rabbits.
Mailmen do it at the mail boxes.
Maintenance men sweep 'em off their feet.
Malingerers do it as long as they can't get out of it.
Mall walkers do it slowly.
Managers do it by delegation.
Managers have someone do it for them.
Managers make others do it.
Managers supervise others.
Marketing reps do it on commission.
Married people do it with frozen access.
Masons do it secretively.
Match makers do it with singles.
Match makers do it with sticks.
Math majors do it by example.
Math majors do it by induction.
Math majors do it with a pencil.
Mathematicians do it as a finite sum of an infinite series.
Mathematicians do it as continuous function.
Mathematicians do it associatively.
Mathematicians do it commutatively.
Mathematicians do it constantly.
Mathematicians do it continuously.
Mathematicians do it discretely.
Mathematicians do it exponentially.
Mathematicians do it forever if they can do one and can do one more.
Mathematicians do it functionally.
Mathematicians do it homologically.
Mathematicians do it in fields.
Mathematicians do it in groups.
Mathematicians do it in imaginary domain.
Mathematicians do it in imaginary planes.
Mathematicians do it in numbers.
Mathematicians do it in theory.
Mathematicians do it on smooth contours.
Mathematicians do it over and under the curves.
Mathematicians do it parallel and perpendicular.
Mathematicians do it partially.
Mathematicians do it rationally.
Mathematicians do it reflexively.
Mathematicians do it symmetrically.
Mathematicians do it to prove themselves.
Mathematicians do it to their limits.
Mathematicians do it totally.
Mathematicians do it transcendentally.
Mathematicians do it transitively.
Mathematicians do it variably.
Mathematicians do it with imaginary parts.
Mathematicians do it with linear pairs.
Mathematicians do it with logs.
Mathematicians do it with Nobel's wife.
Mathematicians do it with odd functions.
Mathematicians do it with prime roots.
Mathematicians do it with relations.
Mathematicians do it with rings.
Mathematicians do it with their real parts.
Mathematicians do it without limit.
Mathematicians do over an open unmeasurable interval.
Mathematicians have to prove they did it.
Mathematicians prove they did it.
Mathematicians take it to the limit.
Mds only do it if you have appropriate insurance.
Mechanical engineering majors do it in gear.
Mechanical engineers do it automatically.
Mechanical engineers do it with fluid dynamics.
Mechanical engineers do it with stress and strain.
Mechanics do it from underneath.
Mechanics do it on their backs.
Mechanics do it with oils.
Mechanics have to jack it up and then do it.
Medical researchers do it with mice.
Medical researchers make mice do it first.
Medievalists do it with fake, fluffy weapons.
Merchants do it to customers.
Mermaids can't do it.
Metallurgists are screw'n edge.
Metallurgists do it in the street.
Meteorologists do it unpredictably.
Methodists do it by numbers.
Milkmen deliver twice a week.
Millionaires pay to have it done.
Milton Berle does it in his BVDs.
Mimes do it without a sound.
Mimes don't do it; everyone hates a mime.
Miners do it deeper than divers.
Miners sink deeper shafts.
Ministers do it on Sundays.
Ministers do it vicariously.
Missile engineers do it in stages.
Missilemen have better thrust.
Mobius strippers never show you their back side.
Models do it beautifully.
Models do it in any position.
Models do it with all kinds of fancy dresses on.
Modem manufacturers do it with all sorts of characters.
Molecular biologists do it with hot probes.
Monks do it by hand.
Moonies do it within sects.
Morticians do it gravely.
Most of the graduate students get aids.
Mothers do it with their children.
Motorcyclists do it with spread legs.
Motorcyclists like something hot between their legs.
Moto-X'ers do it in the dirt.
Mountain climbers do it on the rocks.
Mountaineers do it with ropes.
Movie stars do it on film.
Mudders do it over the internet.
Multitaskers do it everywhere: concurrently.
Music hackers do it at 3 am.
Music hackers do it audibly.
Music hackers do it in concert.
Music hackers do it in scores.
Music hackers do it with more movements.
Music hackers do it with their organs.
Music hackers want to do it in realtime.
Music majors do it in a chord.
Musicians do it rhythmically.
Musicians do it with rhythm.
Native Amazonians do it with poison tips down along narrow tubes.
Native Americans do it with reservations.
Navigators can show you the way.
Necrophiliacs do it cryptically.
Necrophiliacs do it until they are dead tired.
Nerds do it in rot13.
Network hackers know how to communicate.
Network managers do it in many places at once.
New users do it after reading the helpfile.
New users do it after receiving advice.
Newsmen do it at six and eleven.
Newspaper boys do it in front of every door.
Nike just does it.
Nike wants you to just do it.
Ninjas do it silently.
Ninjas do it in articulated sock.s
Non-smokers do it without huffing and puffing.
Novices do it with instructions.
Nuclear engineers do it hotter than anyone else.
Nukes do it with more power.
Number theorists do it "69".
Nuns do it out of habit.
Nuns do it with the holy spirit.
Nurses are prepared to resuscitate.
Nurses call the shots.
Nurses do it as the doctor ordered.
Nurses do it painlessly.
Nurses do it to patients.
Nurses do it with aseptic technique.
Nurses do it with care.
Nurses do it with fluid restriction.
Nurses do it with TLC.
Oarsmen stroke till it hurts.
Obsessive-compulsive people do it habitually.
Oceanographers do it down under.
Operator does it automatically.
Operator does it in the cty.
Operators do it person-to-person.
Operators mount everything.
Operators really know how to mount it.
Optimists do it without a doubt.
Optometrists do it eyeball-to-eyeball, since they always see eye-to-eye.
Optometrists do it face-to-face.
Organists do it with both hands and both feet.
Organists pull out all the stops and do it with their feet.
Orthodontists do it with braces.
OS people would do it if only they didn't 'deadlock'.
Osteopaths do it until you feel no pain.
Painters do it out in the field with brightly coloured sticky substances.
Painters do it with longer strokes.
Paladins do it good or not at all.
Paladins don't do it.
Pantomimists do it silently.
Paramedics can revive anything.
Paratroopers do it by vertical insertion.
Particle physicists do it energetically.
Particle physicists to it with *charm*.
Pascal programmers are better structured.
Pascal programmers repeat it.
Pascal users do it with runtime support.
Pastors do it with spirit.
Pathologists do it with corpses.
Patients do it in bed, sometimes with great pain.
Pediatricians do it with children.
Penguins do it down south.
Perfectionists do it better.
Perverted hackers do it with pops.
Pessimists can't do it.
Pessimists do it with a sigh.
Pharmacologists do it by prescription.
Pharmacologists do it via the oral route.
Pharmacologists do it with affinity.
Philosophers do it for pure reasons.
Philosophers do it in their minds.
Philosophers do it with their minds.
Philosophers go deep.
Philosophers think about doing it.
Philosophers think they do it.
Philosophers wonder why they did it.
Photographers are better developed.
Photographers do it at 68 degrees or not at all.
Photographers do it in the dark.
Photographers do it while exposing.
Photographers do it with "enlargers."
Photographers do it with a flash.
Photographers do it with a zoom.
Phototherapists do it with the lights on.
Physicists do it a quantum at a time.
Physicists do it at the speed of light.
Physicists do it at two places in the universe at one time.
Physicists do it attractively.
Physicists do it energetically.
Physicists do it in black holes.
Physicists do it in waves.
Physicists do it like Einstein.
Physicists do it magnetically.
Physicists do it on accelerated frames.
Physicists do it particularly.
Physicists do it repulsively.
Physicists do it strangely.
Physicists do it up and down, with charming color, but strange!
Physicists do it with black bodies.
Physicists do it with charm.
Physicists do it with large expensive machinery.
Physicists do it with rigid bodies.
Physicists do it with tensors.
Physicists do it with their vectors.
Physicists do it with uniform harmonic motion.
Physicists get a big bang.
Physics majors do it at the speed of light.
Piano players have faster fingers.
Piano students learn on their teachers' instruments.
Pilots do it higher.
Pilots do it in the cockpit.
Pilots do it on the wing.
Pilots do it to get high.
Pilots do it with flare.
Pilots keep it up longer.
Pilots stay up longer.
Ping-pong players always smash balls.
Pirates do it for the booty.
Pirates do it with stumps.
Pizza delivery boys come in 30 minutes, or it's free.
Plasma physicists do it with everything stripped off.
Plasterers to it hard.
Players do it in a team.
Plumbers do it under the sink.
Plumbers do it with plumber's friends.
Podiatrists do it with someone else's feet.
Poker players do it with their own hand.
Polaroid does it in one step.
Polaroid does it in seconds.
Pole vaulters do it with long, flexible instruments.
Policemen like big busts.
Policemen never cop out.
Politicians do it for 4 years then have to get re-elected.
Politicians do it for 4 years then have to get re-erected.
Politicians do it to everyone.
Politicians do it to make the headlines.
Politicians do it with everyone.
Politicians do it, but they stay in too long and make you pay for it afterwards.
Polymer chemists do it in chains.
Pool cleaners do it wet.
Popes do it in the woods.
Post office workers do it overnight, guaranteed for $8.90.
Postmen are first class males.
Postmen come slower.
Presbyterians do it decently and in order.
Priests do it with amazing grace.
Prince Charles does it in succession.
Printers do it without wrinkling the sheets.
Printers reproduce the fastest.
Probate lawyers do it willingly.
Procrastinators do it later.
Procrastinators do it tomorrow.
Procrastinators will do it tomorrow.
Procrastinators will do it when they get around to it.
Proctologists do it in the end.
Proctologists do it with a finger up where the sun don't shine.
Professors do it by the book.
Professors do it from a grant.
Professors do it with class.
Professors don't do it; they leave it as an exercise for their students.
Professors forget to do it.
Programmers cycle forever, until you make them exit.
Programmers do it all night.
Programmers do it bottom-up.
Programmers do it by pushing and popping.
Programmers do it in higher levels.
Programmers do it in loops.
Programmers do it in software.
Programmers do it on command.
Programmers do it top down.
Programmers do it with bugs.
Programmers do it with disks.
Programmers have: bigger disks.
Programmers peek before they poke.
Programmers repeat it until done.
Programmers will do it all night, but only if you are debugged.
Prolog programmers are a cut above the rest.
Promiscuous hackers share resources.
Prostitutes do it at illegal addresses.
Prostitutes do it for profit.
Protestants do it unwillingly.
Psychiatrists do it for at least fifty dollars per session.
Psychiatrists do it on the couch.
Psychologists do it with rats.
Psychologists think they do it.
Public speakers do it orally.
Pyrotechnicians do it with flare.
Pyrotechnicians do it with a blinding flash.
Quakers do it quietly.
Quantum mechanics do it in leaps.
Quantum physicists do it on time.
Racers do it with their horses.
Racers like to come in first.
Racquetball players do it off the wall.
Radio amateurs do it with more frequency.
Radio amateurs do it with two meters.
Radio and TV announcers broadcast it.
Radio engineers do it till it megahertz.
Radio engineers do it with frequency.
Radiocasters do it in the air.
Radiologists do it with high frequency.
Railroaders do it on track.
Rally drivers do it sideways.
Rangers do it in the woods.
Rangers do it with all the animals in the woods.
Raquetball players do it with blue balls.
Real estate people know all the prime spots.
Receptionists do it over the phone.
Recyclers do it again and again and again.
Reporters do it daily.
Reporters do it for a story.
Reporters do it for the sensation it causes.
Republicans do as their lobbyists tell them to.
Republicans do it to poor people.
Research professors do it only if they get grants.
Researchers are still looking for it.
Researchers do it with control.
Retailers move their merchandise.
RISC assembly programmers do it 1073741824 times a second.
Robots do it mechanically.
Rocket scientists do it with higher thrust.
Rocketeers do it on impulse.
Roller-skaters like to roll around.
Rolling Stones magazine does it where they rock.
Roofers do it on top.
Roosters do it coquettishly.
Royal guards do it in uniforms.
Rugby players do it with leather balls.
Runners do it with vigor.
Runners get into more pants.
Sailors do it ad nauseam.
Sailors do it after cruising the seven seas.
Sailors get blown off shore.
Sailors like to be blown.
Salespeople have a way with their tongues.
Sax players are horny.
Saxophonists have curved ones.
Sceptics doubt it can be done.
Scientists discovered it.
Scientists do it experimentally.
Scientists do it with plenty of research.
Scotsmen do it with amazing grace.
Scuba divers do it deeper.
Sculptors beat at it until bits fall off.
Second fiddles do it vilely.
Secretaries do it from 9 to 5.
Seismologists do it when the earth shakes.
Seismologists make the earth move.
Semanticists do it with meaning.
Senators do it on the floor.
Sergeants do it privately.
Set theorists do it with cardinals.
Shakespearean scholars do it... Or don't do it, that is the question....
Sheep do it when led astray.
Shubert didn't finish it.
Simulation hackers do it with models.
Singers do it with microphones.
Skaters do it on ice.
Skeet shooters do it 25 times in 9 different positions.
Skeletons do it with a bone.
Skeptics doubt about it.
Skiers do it spread eagled.
Skiers do it with poles.
Skiers go down fast.
Skunks do it instinctively.
Sky divers do it in the air.
Sky divers never do it without a chute.
Skydivers are good till the last drop.
Skydivers do it at great heights.
Skydivers do it in the air.
Skydivers do it sequentially.
Skydivers go down faster.
Skydivers go in harder.
Skydivers never do it without a chute.
Slaves do it for the masters.
Small boat sailors do it by pumping, rocking, and ooching.
Smalltalk programmers have more methods.
Snakes do it in the grass.
Soap manufacturers do it with Lava.
Soap manufacturers do it with Zest.
Soccer players do it for kicks.
Soccer players do it in 90 minutes.
Soccer players have leather balls.
Sociologists do it with class.
Sociologists do it with standard deviations.
Software designers do it over and over until they get it right.
Software designers do it with system.
Software reliablity specialists keep it up longer.
Software testers do it over and over again.
Solar astronomers do it all day.
Soldiers do it standing erect.
Soldiers do it with a machine gun.
Soldiers do it with shoot.
Sonarmen do it aurally.
Sopranos do it in unison.
Soviet hardline leaders do it with tanks.
Sparrows do it for a lark.
Speakers do it with pointers.
Speaking clocks do it on the third stroke.
Spectroscopists do it until it hertz.
Spectroscopists do it with frequency and intensity.
Speech pathologists are oral specialists.
Speleologists make a science of going deeper.
Spellcasters do it with their rods/staves/wands.
Spelunkers do it in narrow dark places.
Spelunkers do it underground.
Spelunkers do it while wearing heavy rubber protective devices.
Spies do it under cover.
Sportscasters like an instant replay.
Sprinters do it after years of conditioning.
Sprinters do it in less than 10 seconds.
Squatter girls do it with crowbars.
St. Matthew did it passionately.
Stage hands do it behind the scenes.
Stage hands do it in the dark.
Stage hands do it on cue.
Statisticians do it continuously but discretely.
Statisticians do it when it counts.
Statisticians do it with 95% confidence.
Statisticians do it with large numbers.
Statisticians do it with only a 5% chance of being rejected.
Statisticians do it. After all, it's only normal.
Statisticians probably do it.
Steamfitters do it with a long hot pipe.
Stewardesses do it in the air.
Stragglers do it in the rear.
Students do it as exercises.
Students do it on a guaranteed loan.
Students do it with their students.
Students use their heads.
Submariners do it deeper.
Submariners use their torpedoes.
Supercomputer users do it in parallel.
Surfers do it in waves.
Surfers do it standing up.
Surfers do it with their wives, or, if unmarried, with their girl friends.
Surgeons are smooth operators.
Surgeons do it incisively.
Swashbucklers do it with three feet of steel.
Swimmers do it in the lanes.
Swimmers do it in the water.
Swimmers do it under water.
Swimmers do it with a breast stroke.
Swimmers do it with better strokes.
Sysops do it with their computers.
System hackers are always ready.
System hackers get it up quicker.
System hackers keep it up longer.
System hackers know where to poke.
System hackers swap on demand.
System managers do it with pencils.
Systems go down on their hackers.
Systems have black boxes.
Systems programmers keep it up longer.
Tailors come with no strings attached.
Tailors make it fit.
Tap dancers do it with their feet.
Taxi cab drivers come faster.
Taxi cab drivers do it all over town.
Taxi drivers do it all over town.
Taxidermists mount anything.
Teacher assistants do it with class.
Teachers do it 50 times after class.
Teachers do it repeatedly.
Teachers do it with class.
Teachers make _you_ do it till you get it right.
Technical writers do it manually.
Technicians do it with frequency.
Technicians do it with greater frequency.
Technicians do it with high voltage probes.
Technicians do it with mechanical assistance.
Teddy bears do it with small children.
Teddy Roosevelt did it softly, but with a big stick.
Telephone Co. employees let their fingers do the walking.
Tellers can handle all deposits and withdrawals.
Tennis players do it in sets.
Tennis players do it in their shorts.
Tennis players have fuzzy balls.
Test makers do it sometimes/always/never.
Testators do it willingly.
Texans do it with oil.
The Air Force, aims high, shoots low.
The Army does it being all that they can be.
The Energizer bunny does it and keeps going and going, and going, and going.
The FBI does it under cover.
Theater majors do it with an audience.
Theater techies do it in the dark, on cue.
Theoretical astronomers only *think* about it.
Theoreticians do it conceptually.
Theoreticians do it with a proof.
Thieves do it in leather.
Thieves do it when you're not looking.
Thieves do it with their lock picks.
Thieves do it with tools.
Trainees do it as practice.
Trampoline acrobats do it in the air.
Trampoline acrobats do it over a net.
Trampoline acrobats do it swinging from bars.
Trampoline acrobats do it under the big top.
Tree men do it in more crotches than anyone else.
Tribiological engineers do it by using lubricants.
Trombone players are constantly sliding it in and out.
Trombone players do it faster.
Trombone players do it in 7 positions.
Trombone players do it with slide action finger control.
Trombone players do it with slide oil.
Trombone players have something that's always long and hard.
Trombone players slide it in and out.
Trombone players use more positions.
Trombones do it faster.
Trombonists use more positions.
Truck drivers carry bigger loads.
Truck drivers do it on the road.
Truck drivers have bigger dipsticks.
Truckers have moving experiences.
Trump does it with cash.
Trumpet players blow the best.
Trumpeters blow hard.
Tuba players do it with big horns.
Tubas do it deeper.
TV evangalists do more than lay people.
TV repairmen do it in sync.
TV repairmen do it with a vertical hold.
Twin Peaks fans do it with logs.
Two meter operators do it with very high frequency.
Typesetters do it between periods.
Typists do it in triplicate.
Typographers do it to the letter.
Typographers do it with tight kerning.
Ultimate players do it horizontally.
Undertakers do it with corpses.
Unix don't do it.
Unix hackers go down all the time.
Unix programmers must c her's.
Urologists do it in a bottle.
Usenet freaks do it with hard drives.
Usenet news freaks do it with many groups at once.
Ushers do it in the dark.
Usurers do it with high interests.
Vacationers do it in a leisure way.
Vagrants do it everywhere.
Valuers really know the price.
Vampires do it 'til the sun comes up.
Vanguard do it ahead of everyone else.
Vegetarians don't do it with meats.
Vendors try hard to sell it.
Verifiers check on it.
Versifiers write poems for it.
Veterans have much more experience than the fresh-handed.
Veterinarians are pussy lovers.
Veterinarians do it with animals.
Veterinarians do it with sick animals.
Vicars do it with amazing grace.
Vicars substitute others to.
Vice principals do it with discipline.
Victims are those who got it.
Victors know how hard to win it.
Viewers do it with eyes.
Vilifiers say others don't do it well.
Villagers do it provincially.
Violinists do it gently.
Violinists prefer odd positions.
Violoncellists do it low.
Virtuosi appreciate it.
Visa, its everywhere you want to be.
Visitors come and see it.
Vocalists are good in their mouths.
Volcanologists know how violent it can be.
Voles dick through it.
Volleyball players keep it up.
Volunteers do it willingly.
Votarists decide to contribute themself.
Voters will decide who can do it.
Voyagers do it in between the sea and the sky.
Vulcans do it logically.
Waiters and waitresses do it for tips.
Waitresses do it with chopsticks.
Waitresses serve it hot.
Waitresses serve it piping hot.
Water skiers come down harder.
Water skiers do it with cuts.
Weather forecasters do it with crystal balls.
Weathermen do it with crystal balls.
Welders do it with hot rods.
Welders fill all cracks.
Well diggers do it in a hole.
Werewolves do it as man or beast.
Werewolves do it by the light of the full moon.
Weathermen do it with lightning strokes.
Woodwind players have better tonguing.
Wrestlers know the best holds.
Wrestlers try not to do it on their backs.
Writers have novel ways.
WW I GIs did it over there.
X-ray astronomers do it with high energy.
Xerox does it again and again and again and again.
Zen buddhists do it because they don't want to do it because they want to do it.
Zen monks do it and don't do it.
Zippermakers do it on the fly.
Zippy does it on his lunch break.
Zoologists do it with animals.'''

