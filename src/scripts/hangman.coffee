# Description:
#   The game of Hangman.
#   Words and definitions are sourced via the Wordnik API. You'll need an API
#   key from http://developer.wordnik.com/
#
# Dependencies:
#   None
# 
# Configuration:
#   WORDNIK_API_KEY
#
# Commands:
#   hubot hangman - Display the state of the current game
#   hubot hangman <letterOrWord> - Make a guess
#
# Author:
#   harukizaemon

class Game

  constructor: (word, @definitions) ->
    @word = word.toUpperCase()
    @wordLetters = @word.split(//)
    @answerLetters = ("_" for letter in @wordLetters)
    @remainingGuesses = 9
    @previousGuesses = []
    @message = null

  isFinished: ->
    this.wasAnswered() or this.wasHung()

  wasAnswered: ->
    "_" not in @answerLetters

  wasHung: ->
    @remainingGuesses == 0

  guess: (guess) ->
    if !guess
      this.noGuess()
      return

    guess = guess.trim().toUpperCase()

    if guess in @previousGuesses
      this.duplicateGuess(guess)
    else
      @previousGuesses.push(guess)
      switch guess.length
        when 1 then this.guessLetter(guess)
        when @word.length then this.guessWord(guess)
        else this.errantWordGuess(guess)

  guessLetter: (guess) ->
    indexes = (index for letter, index in @wordLetters when guess == letter)
    if indexes.length > 0
      @answerLetters[index] = @wordLetters[index] for index in indexes
      this.correctGuess("Yes, there #{isOrAre(indexes.length, guess)}")
    else
      this.incorrectGuess("Sorry, there are no #{guess}'s")

  guessWord: (guess) ->
    if guess == @word
      @answerLetters = @wordLetters
      this.correctGuess("Yes, that's correct")
    else
      this.incorrectGuess("Sorry, the word is not #{guess}")

  noGuess: ->
    @message = null

  errantWordGuess: (guess) ->
    @message = "The word #{guess} isn't the correct length so let's pretend that never happened, shall we?"

  duplicateGuess: (guess) ->
    @message = "You already tried #{guess} so let's pretend that never happened, shall we?"

  correctGuess: (message) ->
    @message = message

  incorrectGuess: (message) ->
    @remainingGuesses -= 1 if @remainingGuesses > 0
    @message = message

  eachMessage: (callback) ->
    callback(@message) if @message

    if this.isFinished()
      if this.wasHung()
        callback("You have no remaining guesses")
      else if this.wasAnswered()
        callback("Congratulations, you still had #{pluralisedGuess(@remainingGuesses)} remaining!")

      callback("The #{@wordLetters.length} letter word was: #{@word}")
      callback(@definitions)
    else
      callback("The #{@answerLetters.length} letter word is: #{@answerLetters.join(' ')}")
      callback("You have #{pluralisedGuess(@remainingGuesses)} remaining")

module.exports = (robot) ->
  gamesByRoom = {}

  robot.respond /hangman( .*)?$/i, (msg) ->

    if process.env.WORDNIK_API_KEY == undefined
      msg.send("Missing WORDNIK_API_KEY env variable.")
      return

    room = msg.message.user.room

    play msg, gamesByRoom[room], (game) ->
      gamesByRoom[room] = game
      game.guess(msg.match[1])
      game.eachMessage (message) -> msg.send(message)

play = (msg, game, callback) ->
  if !game or game.isFinished()
    generateWord msg, (word, definitions) -> callback new Game(word, definitions)
  else
    callback(game)

generateWord = (msg, callback) ->
  msg.http("http://api.wordnik.com/v4/words.json/randomWord")
    .query
      hasDictionaryDef: true
      minDictionaryCount: 3
      minLength: 5
    .headers
      api_key: process.env.WORDNIK_API_KEY
    .get() (err, res, body) ->
      result = JSON.parse(body)
      word = if result
        result.word
      else
        "hangman"

      defineWord(msg, word, callback)

defineWord = (msg, word, callback) ->
  msg.http("http://api.wordnik.com/v4/word.json/#{escape(word)}/definitions")
    .header("api_key", process.env.WORDNIK_API_KEY)
    .get() (err, res, body) ->
      definitions = JSON.parse(body)

      if definitions.length == 0
        callback(word, "No definitions found.")
      else
        reply = ""
        lastSpeechType = null

        definitions = definitions.forEach (def) ->
          # Show the part of speech (noun, verb, etc.) when it changes
          if def.partOfSpeech != lastSpeechType
            reply += " (#{def.partOfSpeech})\n" if def.partOfSpeech != undefined

          # Track the part of speech
          lastSpeechType = def.partOfSpeech

          # Add the definition
          reply += "  - #{def.text}\n"

        callback(word, reply)

isOrAre = (count, letter) ->
  if count == 1
    "is one #{letter}"
  else
    "are #{count} #{letter}'s"

pluralisedGuess = (count) ->
  if count == 1
    "one guess"
  else
    "#{count} guesses"
