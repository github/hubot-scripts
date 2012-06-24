# Description:
#   Respond to custom answers
#
# Dependencies:
#   redis-brain.coffee
#
# Configuration:
#   None
#
# Commands:
#   hubot say something about <topic> - will say something he knows about the subject
#   hubot when asked <regexp_of_question> answer <response> - teach your bot to answer to <regexp_of_question> with <response>
#   hubot forget answers - remove every teached answer from bot brain
#
# Author:
#   NNA

module.exports = (robot) ->

  basic_knowledge = {
    1: {regexp: "(what( is|'s))?( your)? favorite( programming)? language", answer: 'CoffeeScript'},
    2: {regexp: 'favorite (os|operating system|platform)', answer: 'Linux'}
  }

  respondToAnswer = (item) ->
    robot.respond new RegExp(item.regexp, 'i'), (msg) ->
      for key, item of robot.brain.data.knowledge
        break if msg.match[0].replace(robot.name,'').match new RegExp(item.regexp, 'i')
      msg.send item.answer if item?.answer?

  knowledgeAbout = (subject) ->
    for key, item of robot.brain.data.knowledge
      if subject.replace(robot.name,'').match new RegExp(item.regexp, 'i')
        found = true ; break
    if found == true
      @.key = key ; @.item = item
      return @
    else
      return null

  robot.brain.on 'loaded', =>
    robot.logger.info "Loading knowledge"
    robot.brain.data.knowledge ?= {}

    robot.brain.data.knowledge = basic_knowledge if Object.keys(robot.brain.data.knowledge).length == 0
    for key, item of robot.brain.data.knowledge
      respondToAnswer(item)

  robot.respond /(when )?asked (.*) (reply|answer|return|say) (.*)$/i, (msg) ->
    question = msg.match[2]
    answer = msg.match[4]

    result = new knowledgeAbout(question)

    if result.key?
      if result.item.answer == answer
        msg.send "I already know that"
      else
        msg.send "I thought \"#{result.item.answer}\" but I will now answer \"#{answer}\""
        robot.brain.data.knowledge[result.key].answer = answer
    else
      new_question = {regexp: question, answer: answer}
      next_id = Object.keys(robot.brain.data.knowledge).length+1
      robot.brain.data.knowledge[next_id] = new_question
      respondToAnswer(new_question)
      msg.send "OK, I will answer \"#{answer}\" when asked \"#{question}\""

  robot.respond /(forget)( all)? (answers|replies|everything)$/i, (msg) ->
    for key, item of robot.brain.data.knowledge
      i = 0
      while i < robot.listeners.length
        robot.listeners.splice(i,1) if String(item.regexp) in String(robot.listeners[i].regex)
        i++
    robot.brain.data.knowledge = {}
    msg.send "OK, I've forgot all answers"

  robot.respond /((say )?s(ome)?thing|talk( to me)?)( about (.*))?$/i, (msg) ->
    subject = msg.match[6]
    knowledge = robot.brain.data.knowledge
    if JSON.stringify(knowledge) is '{}'
      msg.send "I don't know anything, teach me something please ..."
    else
      if subject is undefined
        answer = knowledge[msg.random(Object.keys(knowledge))].answer
        msg.send "I would say #{answer}"
      else
        result = new knowledgeAbout(subject)
        if result.key?
          msg.send "If you ask #{result.item.regexp}, I would answer #{result.item.answer}"
        else
          msg.send "I don't know anything about #{subject}, please teach me something about it"
