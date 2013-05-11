# Description:
#   Take notes on scrum daily meetings
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SCRUMNOTES_PATH - if set, folder where daily notes should be saved as json files (otherwise they just stay on robot brain)
#
# Commands:
#   hubot take scrum notes - Starts taking notes from all users in the room (records all messages starting with yesterday, today, tomorrow, sun, mon, tue, wed, thu, fri, sat, blocking)
#   hubot stop taking notes - Stops taking scrum notes (if a path is configured saves day notes to a json file)
#   hubot scrum notes - shows scrum notes taken so far
#   hubot are you taking notes? - hubot indicates if he's currently taking notes
#
# Author:
#   benjamin eidelman

env = process.env
fs = require('fs')

module.exports = (robot) ->
  
  # rooms where hubot is hearing for notes
  hearingRooms = {}
  messageKeys = ['blocking', 'blocker', 'yesterday', 'today', 'tomorrow', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']

  getDate = ->
    today = new Date()
    dd = today.getDate()
    mm = today.getMonth()+1
    yyyy = today.getFullYear()
    if (dd<10) 
      dd='0'+dd
    if (mm<10)
      mm='0'+mm
    return yyyy+'-'+mm+'-'+dd

  listener = null

  startHearing = ->  

    if (listener)
      return

    listenersCount = robot.catchAll (msg) ->

      if (!hearingRooms[msg.message.user.room])
        return

      today = getDate()
      name = msg.message.user.name

      robot.brain.data.scrumNotes ?= {};
      notes = robot.brain.data.scrumNotes[today] ?= {}

      notes._raw ?= [];
      notes._raw.push([new Date().getTime(), name, msg.message.text])

      keyValue = /^([^ :\n\r\t]+)[ :\n\t](.+)$/m.exec(msg.message.text)
      if (keyValue)
        notes[name] ?= {}
        key = keyValue[1].toLowerCase()
        if (key in messageKeys)
          notes[name][key] ?= [];
          notes[name][key].push(keyValue[2])

    listener = robot.listeners[listenersCount - 1]

  stopHearing = ->

    if (!listener)
      return

    listenerIndex = -1
    for list, i in robot.listeners
      if list is listener
        listenerIndex = i
        break
    if (listenerIndex >= 0)
        setTimeout ->
          robot.listeners.splice(i, 1)
        , 0
    listener = null

  mkdir = (path, root) ->

    dirs = path.split('/')
    dir = dirs.shift()
    root = (root||'')+dir+'/'

    try
      fs.mkdirSync(root)
    catch e
        # dir wasn't made, something went wrong
        if (!fs.statSync(root).isDirectory())
          throw new Error(e)

    return !dirs.length || mkdir(dirs.join('/'), root)

  robot.respond /(?:show )?scrum notes/i, (msg) ->

    today = getDate()

    notes = robot.brain.data.scrumNotes?[today]

    if !notes
      msg.reply('no notes so far')
    else

      # build a pretty version
      response = []
      for own user, userNotes of notes
        if user != '_raw'
          response.push(user, ':\n')
          for key in messageKeys
            if userNotes[key]
              response.push('  ', key, ': ', userNotes[key].join(', '), '\n')

      msg.reply(response.join(''))

  robot.respond /take scrum notes/i, (msg) ->

    startHearing()

    hearingRooms[msg.message.user.room] = true

    msg.reply('taking scrum notes, I hear you');

  robot.respond /are you taking (scrum )?notes\?/i, (msg) ->

    takingNotes = !!hearingRooms[msg.message.user.room]

    msg.reply(if takingNotes then 'Yes, I\'m taking scrum notes' else 'No, I\'m not taking scrum notes')

  robot.respond /stop taking (?:scrum )?notes/i, (msg) ->

    delete hearingRooms[msg.message.user.room];

    msg.reply("not taking scrum notes anymore");

    today = getDate()
    notes = robot.brain.data.scrumNotes?[today]

    users = (user for user in Object.keys(notes) when user isnt '_raw')

    count = if notes then users.length else 0

    status = "I got no notes today"
    if count > 0
      status = ["I got notes from ", users.slice(0,Math.min(3, users.length - 1)).join(', '), " and ", if users.length > 3 then (users.length-3)+' more' else users[users.length-1]].join('')

    msg.reply(status);

    if (Object.keys(hearingRooms).length < 1)
      stopHearing()

    saveTo = process.env.HUBOT_SCRUMNOTES_PATH 

    if (saveTo)
      mkdir(saveTo + '/scrumnotes')
      fs.writeFileSync(saveTo + '/scrumnotes/' + today + '.json', JSON.stringify(notes, null, 2))
      msg.send('scrum notes saved at: /scrumnotes/' + today + '.json')

