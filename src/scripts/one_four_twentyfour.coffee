# Description:
#   A drunkly coded, ASCII version of the famous game.
#   Sort of assumes Campfire
#   Game mechanics are easy: http://bruteforcex.blogspot.com/2008/03/1-4-24-dice-game.html
# 
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   dice start - starts a game of one, four, twenty four
#   dice take <dice letters> - takes dice at given levels
#   dice stats - displays the stats for the game
#
# Author:
#   zbowling

dieMap = ['A','B','C','D','E','F']


class BuddhaGame
  constructor: (@robot,@player) ->
    @diceLeft = 6
    @diceTaken = []
    @lastDice = []
    @steps = 0
    
  
  rollRemainingDice: () ->
    @lastDice = []
    printlines = ['','','','','','','']
    for dieIdx in [0...@diceLeft]
      die = @randomDice()
      diestr = @diceString(die,dieMap[dieIdx],die)
      dielines = diestr.split "\n"
      for i in [0...printlines.length]
        printlines[i] += dielines[i]
      @lastDice.push die
    printlines
  
  roll: ->
    "new game!\n" + 
    @rollRemainingDice().join("\n")
  
  
  take: (diceToTake) ->
    dieLetters = diceToTake.toUpperCase().replace(" ","").split("") 
    lastDiceLeftCount = @diceLeft
    for dieLetter in dieLetters
      dieIndex = dieMap.indexOf dieLetter
      if dieIndex != -1 and dieIndex < @lastDice.length
        die_val = @lastDice[dieIndex]
        if die_val != -1
          @diceTaken.push die_val
          @lastDice[dieIndex] = -1 #marking it invalid so you can pick it twice
          @diceLeft -= 1

    if @diceLeft == lastDiceLeftCount
      return "(you didn't pick any dice.)"
    
    @steps += 1
    
    printlines = ['','','','','','','']
    if @diceLeft > 1
      printlines = @rollRemainingDice()
      for i in [0...printlines.length]
        printlines[i] += "\t  > "
    else if @diceLeft == 1 #only one left so lets just end the suffering
      die = @randomDice()
      @diceTaken.push die
      @diceLeft = 0
      
    takenString = @diceTakenStringArray()
    for i in [0...printlines.length]
      printlines[i] += takenString[i]
      
    return_str = printlines.join("\n") + "\n" + @calculateScoreString() 
    
    if @diceLeft <= 0
      return_str += "\nNice job!"
    
    return_str
    
  scoreValue: ()->  
    score = 0
    has_one = no
    has_four = no
    for dieIdx in [0...@diceTaken.length]
      dice_val = @diceTaken[dieIdx]
      if dice_val == 4 and has_four == no
        has_four = yes
      else if dice_val == 1 and has_one == no
        has_one = yes
      else
        score += dice_val
    
    if @diceLeft <= 0 and (has_one == no or has_four == no)
      score = 0
      
    {score:score,taken:@diceTaken,hasOne:has_one,hasFour:has_four,steps:@steps}
  
  
  calculateScoreString: () ->
    score = 0
    has_one = no
    has_four = no
    for dieIdx in [0...@diceTaken.length]
      dice_val = @diceTaken[dieIdx]
      if dice_val == 4 and has_four == no
        has_four = yes
      else if dice_val == 1 and has_one == no
        has_one = yes
      else
        score += dice_val
    
    if @diceLeft <= 0 and (has_one == no or has_four == no)
      "score: 0 // bummer..."
    else if has_one == no and has_four == no
      "score: #{score} (you still need to take a 1 and a 4)"
    else if has_one == no and has_four == yes
      "score: #{score} (you still need to take a 1)"
    else if has_four == no and has_one == yes
      "score: #{score} (you still need to take a 4)"
    else
      "score: #{score}" 
        
  diceTakenStringArray: () ->
    printlines = ['','','','','','','']
    has_one = no
    has_four = no
    for dieIdx in [0...@diceTaken.length]
      dice_val = @diceTaken[dieIdx]
      dice_score = "-"
      if dice_val == 4 and has_four == no
        has_four = yes
      else if dice_val == 1 and has_one == no
        has_one = yes
      else
        dice_score = dice_val
      diestr = @diceString(dice_val,"*",dice_score)
      dielines = diestr.split "\n"
      for i in [0...printlines.length]
        printlines[i] += dielines[i]
    printlines
    
  gameover: () ->
    if @diceLeft <= 0
      return true
    else
      return false
    
  randomDice: () ->
    1 + Math.floor(Math.random() * 6)
  
  diceString: (value,i,x) ->
    switch value
      when 1
        "
      #{x}     \n
  --------- \n
  |       | \n
  |   o   | \n
  |       | \n
  --------- \n
      #{i}     \n
        "
      when 2
        "
      #{x}     \n
  --------- \n
  | o     | \n
  |       | \n
  |     o | \n
  --------- \n
      #{i}     \n
        "
      when 3
        "
      #{x}     \n
  --------- \n
  | o     | \n
  |   o   | \n
  |     o | \n
  --------- \n
      #{i}     \n
        "
      when 4
        "
      #{x}     \n
  --------- \n
  | o   o | \n
  |       | \n
  | o   o | \n
  --------- \n
      #{i}     \n
        "
      when 5
        "
      #{x}     \n
  --------- \n
  | o   o | \n
  |   o   | \n
  | o   o | \n
  --------- \n
      #{i}     \n
        "
      when 6
        "
      #{x}     \n
  --------- \n
  | o   o | \n
  | o   o | \n
  | o   o | \n
  --------- \n
      #{i}     \n
        "
  

    
    

class BuddhaLounge
  constructor: (@robot) ->
    @games = []
    @playerdata = []
    @players = []
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.buddhagames?
        @games = @robot.brain.data.buddhagames
      if @robot.brain.data.playerdata?
        @playerdata = @robot.brain.data.playerdata
  
  startGame: (msg, player) ->
    game = new BuddhaGame @robot, player 
    msg.reply "\n" + game.roll()
    @games[player.id] = game
    @robot.brain.data.buddhagames = @games
    if not @players[player.id]?
      @players[player.id] = player
    
    if not @playerdata[player.id]? 
      @playerdata[player.id] = { totalScore: 0, totalGamesStarted: 0, totalGamesFinished: 0, lastScore:0}
    @playerdata[player.id].totalGamesStarted += 1;
    @robot.brain.data.playerdata = @playerdata 
  
  playsound: (player,sound) ->
    if @robot.bot?
      @robot.bot.Room(player.room).sound sound, (err, data) =>
        console.log "campfire error: #{err}" if err
  
  take: (msg, player, take) ->
    if @games[player.id]?
      game = @games[player.id]
      msg.reply "\n" + game.take(take)
      
      scoreValue = game.scoreValue()
      if scoreValue.taken.length == 4 and not (scoreValue.hasOne and scoreValue.hasFour)
        @playsound player, "drama"
      
      if game.gameover()
        if scoreValue.score == 24
          if scoreValue.taken.steps == 1
            @playsound player, "yeah"
          else
            @playsound player, "pushit"
        else if scoreValue.taken.steps == 1 and scoreValue.hasOne and scoreValue.hasFour
          @playsound player, "live"
        else if scoreValue.score >= 22
          @playsound player, "tada"
        else if scoreValue.score >= 18
          @playsound player, "greatjob"
        else if scoreValue.score > 0
          @playsound player, "crickets"
        else
          @playsound player, "trombone"
            
        @playerdata[player.id].lastScore = scoreValue.score
        @playerdata[player.id].totalScore = scoreValue.score + @playerdata[player.id].totalScore
        @playerdata[player.id].totalGamesFinished = @playerdata[player.id].totalGamesFinished + 1
        @robot.brain.data.playerdata = @playerdata 
        delete @games[player.id]
    else
      msg.reply "you aren't playing a game."
    
    @robot.brain.data.buddhagames = @games
      
  playerstats: (player) ->
    "\n#{player.name}: \n
\tlast score: #{@playerdata[player.id].lastScore}\n
\taverage score: #{@playerdata[player.id].totalScore/@playerdata[player.id].totalGamesFinished}\n
\ttotal games finished: #{@playerdata[player.id].totalGamesFinished}\n
\ttotal games started: #{@playerdata[player.id].totalGamesStarted}\n"
  
  
  stats: (msg) ->
    return_str = ""
    for k,v of @players
      player = k
      return_str += @playerstats(v)
    msg.reply return_str
  
  reset: -> 
    @playerdata = []
    @robot.brain.data.playerdata = []

module.exports = (robot) ->
  
  buddha = new BuddhaLounge robot
  
  robot.hear /buddha start|dice start|bdstart/i, (msg) ->
    buddha.startGame msg, msg.message.user
    
  robot.hear /buddha stats|dice stats|bdstat/i, (msg) ->
    buddha.stats msg
    
  robot.hear /buddha reset|dice reset/i, (msg) ->
    buddha.reset msg
    
  robot.hear /(buddha take|dice take|bdt) ([\w .-]+)/i, (msg) ->
    buddha.take msg, msg.message.user, msg.match[2]
