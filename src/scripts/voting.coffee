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
      send_choices
    else
      robot.voting.votes = {}
      create_choices msg.match[1]

      msg.send "Vote started"
      send_choices(msg)

  robot.respond /end vote/i, (msg) ->
    if robot.voting.votes?
      console.log robot.voting.votes

      results = tally_votes()

      msg.send "The results are..."
      for choice, index in robot.voting.choices
        msg.send "#{choice}: #{results[index]}"

      delete robot.voting.votes
      delete robot.voting.choices
    else
      msg.send "There is not vote to end"


  robot.respond /show choices/i, (msg) ->
    send_choices(msg)

  robot.respond /vote for (.+)$/i, (msg) ->
    choice = null

    re = /\d{1,2}$/i
    if re.test(msg.match[1])
      choice = parseInt msg.match[1], 10
    else
      choice = robot.voting.choices.indexOf msg.match[1]

    console.log choice

    sender = robot.usersForFuzzyName(msg.message.user['name'])[0].name

    if valid_choice choice
      robot.voting.votes[sender] = choice
      msg.send "#{sender} voted for #{robot.voting.choices[choice]}"
    else
      msg.send "#{sender}: That is not a valid choice"

  create_choices = (raw_choices) ->
    robot.voting.choices = raw_choices.split(/, /)

  send_choices = (msg) ->

    if robot.voting.choices?
      response = ""
      for choice, index in robot.voting.choices
        response += "#{index}: #{choice}"
        response += "\n" unless index == robot.voting.choices.length - 1
    else
      msg.send "There is not a vote going on right now"

    msg.send response

  valid_choice = (choice) ->
    num_choices = robot.voting.choices.length - 1
    0 <= choice <= num_choices

  tally_votes = () ->
    results = (0 for choice in robot.voting.choices)

    voters = Object.keys robot.voting.votes
    for voter in voters
      choice = robot.voting.votes[voter]
      results[choice] += 1

    results
