# Description
#   Vote on stuff!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot start vote item1, item2, item3, ...
#   hubot vote for N - where N is the choice number or the choice name
#   hubot show choices
#   hubot show votes - shows current votes
#   hubot end vote
#
# Notes:
#   None
#
# Author:
#   antonishen

module.exports = (robot) ->
  robot.voting = {}

  robot.respond /start vote (.+)$/i, (msg) ->

    if robot.voting.votes?
      msg.send "A vote is already underway"
      sendChoices (msg)
    else
      robot.voting.votes = {}
      createChoices msg.match[1]

      msg.send "Vote started"
      sendChoices(msg)

  robot.respond /end vote/i, (msg) ->
    if robot.voting.votes?
      console.log robot.voting.votes

      results = tallyVotes()

      msg.send "The results are..."
      for choice, index in robot.voting.choices
        msg.send "#{choice}: #{results[index]}"

      delete robot.voting.votes
      delete robot.voting.choices
    else
      msg.send "There is not a vote to end"


  robot.respond /show choices/i, (msg) ->
    sendChoices(msg)

  robot.respond /show votes/i, (msg) ->
    results = tallyVotes()

    for choice, index in robot.voting.choices
      msg.send "#{choice}: #{results[index]}"

  robot.respond /vote (for )?(.+)$/i, (msg) ->
    choice = null

    re = /\d{1,2}$/i
    if re.test(msg.match[2])
      choice = parseInt msg.match[2], 10
    else
      choice = robot.voting.choices.indexOf msg.match[2]

    console.log choice

    sender = robot.usersForFuzzyName(msg.message.user['name'])[0].name

    if validChoice choice
      robot.voting.votes[sender] = choice
      msg.send "#{sender} voted for #{robot.voting.choices[choice]}"
    else
      msg.send "#{sender}: That is not a valid choice"

  createChoices = (rawChoices) ->
    robot.voting.choices = rawChoices.split(/, /)

  sendChoices = (msg) ->

    if robot.voting.choices?
      response = ""
      for choice, index in robot.voting.choices
        response += "#{index}: #{choice}"
        response += "\n" unless index == robot.voting.choices.length - 1
    else
      msg.send "There is not a vote going on right now"

    msg.send response

  validChoice = (choice) ->
    numChoices = robot.voting.choices.length - 1
    0 <= choice <= numChoices

  tallyVotes = () ->
    results = (0 for choice in robot.voting.choices)

    voters = Object.keys robot.voting.votes
    for voter in voters
      choice = robot.voting.votes[voter]
      results[choice] += 1

    results
