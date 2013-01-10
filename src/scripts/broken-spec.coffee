# Description:
#   Broken Spec Emailer
#
# Dependencies:
#   "querystring": "0.1.0"
#
# Configuration:
#   HUBOT_TEAM_EMAILS
#
# Commands:
#   None
#
# Author:
#   earlonrails
#
# Additional Requirements
#   unix mail client installed on the system
#
# Notes:
#
#   Broken-spec will have hubot IM the person who just committed, if rspec fails on the CI server.
#   The person will then have one hour to fix their code or hubot will email the entire team.
#
#   Have your ci server wget to hubot when the specs fail ie
#    wget -qO - http://10.1.11.201:5555/hubot/broken-spec?user=earlonrails@email.com\&project=bigProject\&branch=qa\&tag=HAHAHAHUBOTROX
#
#   Have your ci server wget to hubot when the specs passes ie
#    wget -qO - http://10.1.11.201:5555/hubot/great-commit?user=earlonrails@email.com\&project=bigProject\&branch=qa\&tag=lhkldf12314lkjasdf
#
#   Variables
#     emailWorkers - will contain the email timeout and user information


util          = require 'util'
child_process = require 'child_process'
querystring   = require 'querystring'
exec = child_process.exec

LEEWAY = 3600000

emailWorkers = []

findWorkerByProject = (project, workerArray) ->
  for index, worker of workerArray
    if worker.user.badCommit.project == project
      return [ worker, index ]

delay = (ms, func) -> setTimeout func, ms
sendNaughtyEmail = (badBoy, msg) ->
  mailCommand = """echo '#{msg}' | mail -s '#{badBoy.id} is a naughty teammate' -F #{process.env.HUBOT_TEAM_EMAILS}"""
  exec mailCommand, (error, stdout, stderr) ->
    util.print 'stdout: ' + stdout
    util.print 'stderr: ' + stderr
  worker = findWorkerByProject(badBoy.badCommit.project, emailWorkers)
  emailWorkers.splice(worker[1], 1)

module.exports = (robot) ->

  robot.router.get "/hubot/broken-spec", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)
    naughtyUser =
      id: query.user
      type: "chat"
      badCommit:
          fixLeeway: (new Date).getTime() + LEEWAY
          project: query.project
          branch: query.branch
          tag: query.tag

    scolding = """You have broken spec tests on: #{query.project}:#{query.branch}
                  This was a bad commit: #{query.tag}
                  If you don't correct this with-in the hour I will be forced to alert your team."""

    teamEmail = """I regret to inform you that rspec is failing.
                   Here is the data I have:
                   Naughty Person: #{query.user}
                   On project: #{query.project}
                   On branch: #{query.branch}
                   Tag: #{query.tag}"""


    emailTimeout = delay LEEWAY, -> sendNaughtyEmail(naughtyUser, teamEmail)
    emailWorkers.push { user: naughtyUser, message: teamEmail, timeout: emailTimeout }
    robot.send  naughtyUser, scolding
    res.end "Don't be naughty!"


  robot.router.get "/hubot/great-commit", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)
    awesomeUser =
      id: query.user
      type: "chat"
      commit:
        project: query.project
        branch: query.branch
        tag: query.tag

    currentTime = (new Date).getTime()
    if emailWorkers.length > 0
      # loop through the users to out if they fixed it themself or if it was another person
      for key, worker of emailWorkers
        # if the user fixed their own code then check if they were in the LEEWAY grace period
        if worker.user.id == awesomeUser.id and worker.user.badCommit.project == awesomeUser.commit.project and worker.user.badCommit.branch == awesomeUser.commit.branch
          # the user has fixed his broken code in time and should be praised.
          if worker.user.badCommit.fixLeeway > currentTime
            robot.send  awesomeUser, "Thank you for fixing your broken code."
        else if worker.user.badCommit.project == awesomeUser.commit.project and worker.user.badCommit.branch == awesomeUser.commit.branch
          robot.send  awesomeUser, """Thank you for fixing #{worker.user.id}'s broken code.
                                      That person owes you a drink."""
      clearWorker = findWorkerByProject(awesomeUser.commit.project, emailWorkers)
      if clearWorker
        clearTimeout(clearWorker[0].timeout)
        emailWorkers.splice(clearWorker[1], 1)
    res.end "Excellent Commit!"
