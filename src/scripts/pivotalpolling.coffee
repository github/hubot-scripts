# Description:
#   Poll Pivotal for Stories
#
# Dependencies:
#   'xml2json':'0.2.4'
#
# Configuration:
#   HUBOT_PIVOTAL_TOKEN - Your Pivotal API Token https://www.pivotaltracker.com/help/api?version=v3#retrieve_token
#   HUBOT_PIVOTAL_PROJECTS - Comma separated list of projects to check e.g 'engineering,marketing'
#   HUBOT_PIVOTAL_INTERVAL - Seconds between checks, default: 300 (5 Minutes)
#
# Commands:
#   hubot check pivotal - Force the polling to run, right now
#
# Author:
#   brettlangdon
#
xml2json = require('xml2json')

last_check = new Date().getTime()
the_robot = null;
projects = { 'names': []}

token = process.env.HUBOT_PIVOTAL_TOKEN
process.env.HUBOT_PIVOTAL_INTERVAL ?= 300
interval = parseInt(process.env.HUBOT_PIVOTAL_INTERVAL)
interval = interval*1000

process.env.HUBOT_PIVOTAL_PROJECTS ?= ''
if process.env.HUBOT_PIVOTAL_PROJECTS.length > 0
   names = process.env.HUBOT_PIVOTAL_PROJECTS.split(',')
   projects.names = (n.toLowerCase() for n in names)       


get_project_ids = () ->
     if projects.names.length <= 0
         return
     
     the_robot.http('http://www.pivotaltracker.com/services/v3/projects')
              .headers('X-TrackerToken':token)
              .get() (err,res,body) ->
                  if err
                      the_robot.logger.error err
                      return
                           
                  body = xml2json.toJson(body, {object:true})
                  if not body.projects or not body.projects.project
                     return
                  for p in body.projects.project
                      if p.name.toLowerCase() in projects.names
                         projects[p.name.toLowerCase()] = p.id


send = (msg, story)->
     message = "#{story.id['$t']} #{story.name}"
     message += " (#{story.owned_by})" if story.owned_by
     message += " is #{story.current_state}" if story.current_state && story.current_state != "unstarted"
     if not msg
         the_robot.send(null, message)
         the_robot.send(null, story.url)
     else
         msg.send(message)
         msg.send(story.url)

poll = (msg) ->
    since = new Date(last_check)
    since = since.getFullYear() + '/' + (since.getMonth()+1) + '/' + since.getDate() + ' ' + since.getHours() + '%3a' + since.getMinutes() + '%3a' + since.getSeconds()
    for name in projects.names
        the_robot.http('https://www.pivotaltracker.com/services/v3/projects/'+projects[name]+'/stories?filter=modified_since:"' + since + '"')
                 .headers('X-TrackerToken':token)
                 .get() (err,res,body) ->
                     if err
                         the_robot.logger.error err
                         return

                     body = xml2json.toJson(body, {object:true})
                     if not body.stories or not body.stories.story
                        if msg
                           msg.send('Nothing has changed')
                        return                     

                     if body.stories.count == '1'
                        send(msg, body.stories.story)
                     else
                        for story in body.stories.story
                            send(msg, story)

    last_check = new Date().getTime()

module.exports = (robot) ->
    the_robot = robot
    if not token
        robot.logger.error 'HUBOT_PIVOTAL_TOKEN not given'
        return

    if projects.names.length <= 0
        robot.logger.error 'No HUBOT_PIVOTAL_PROJECTS given'
        return


    get_project_ids()    

    setInterval( poll, interval )

    robot.respond /check pivotal/i, (msg) ->
        poll(msg)
