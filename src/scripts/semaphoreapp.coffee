# Description
#   Integration with Semaphore (semaphoreapp.com)
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SEMAPHOREAPP_TRIGGER
#     Comma-separated list of additional keywords that will trigger
#     this script (e.g., "build")
#
#   HUBOT_SEMAPHOREAPP_AUTH_TOKEN
#     Your authentication token for Semaphore API
#
#   HUBOT_SEMAPHOREAPP_NOTIFY_RULES
#     Comma-separated list of rules. A rule consists of a room and an
#     *optional* regular expression separated with a colon (i.e., ':').
#     Right-hand side of a rule is to match branch names, so you can do things
#     like notifying "The Serious Room" for master branch, and discard all other
#     notifications. If you omit right-hand side of a rule then room will
#     be notified for any branch.
#
#     Note: If you're using the built-in Campfire adapter then a "room" would be
#           one of the Campfire room ids configured in HUBOT_CAMPFIRE_ROOMS.
#
#     Examples:
#
#       "The Internal Room"
#         =>  Notifications of any branch go to "The Internal Room".
#
#       "The Serious Room:master"
#         =>  Notifications of master branch go to "The Serious Room",
#             notifications of other branches will be discarded.
#
#       "The Serious Room:master,The Internal Room:(?!master).*"
#         =>  Notifications of master branch go to "The Serious Room",
#             notifications of other branches go to "The Internal Room".
#
#       "The Developers Room:.*(test|experiment).*"
#         =>  Notifications of branches that contain "test" or "experiment"
#             go to "The Developers Room", notifications of other branches
#             will be discarded.
#
# Commands:
#   hubot semaphoreapp status [<project> [<branch>]] - Reports build status for projects' branches
#
# URLs:
#   POST /hubot/semaphoreapp
#     First, read http://docs.semaphoreapp.com/webhooks, then your URL to
#     receive the payload would be "<HUBOT_URL>:<PORT>/hubot/semaphoreapp"
#     or if you deployed Hubot onto Heroku: "<HEROKU_URL>/hubot/semaphoreapp".
#
# Author:
#   exalted

module.exports = (robot) ->
  if process.env.HUBOT_SEMAPHOREAPP_TRIGGER
    trigger = process.env.HUBOT_SEMAPHOREAPP_TRIGGER.split(',').join('|')

  robot.respond new RegExp("(?:semaphoreapp|#{trigger})\\s+status(?:\\s+(\\S+)(?:\\s+(\\S+))?)?\\s*$", "i"), (msg) ->
    semaphoreapp = new SemaphoreApp msg

    # Read parameters
    projectName = msg.match[1]
    branchName = msg.match[2]

    semaphoreapp.getListOfAllProjects (projects) ->
      unless projects.length > 0
        msg.reply "I don't know anything really. Sorry. :cry:"
        return

      # unless projectName
      #   # TODO recall project name for current user
      unless branchName
        branchName = "master"

      unless projectName
        if projects.length > 1
          names = (x.name for x in projects)
          msg.reply "I want to do so many things, trying to decide, but... :sweat: How about #{tellEitherOneOfThese names} instead?"
          return
        else
          project = projects[0]

      unless project?
        for x in projects
          if x.name is projectName
              project = x
              break

      unless project?
        if projects.length > 1
          names = (x.name for x in projects)
          butTellAlsoThis = "How about #{tellEitherOneOfThese names} instead?"
        else
          butTellAlsoThis = "Do you mean \"#{projects[0].name}\" perhaps? :wink:"

        msg.reply "I don't know anything about \"#{projectName}\" project. Sorry. :cry: #{butTellAlsoThis}"
        return

      # TODO remember last asked project name for current user

      unless project.branches.length > 0
        msg.reply "I can't find no branches for \"#{projectName}\" project. Sorry. :cry:"
        return

      for x in project.branches
        if x.branch_name is branchName
          branch = x
          break

      unless branch?
        if project.branches.length > 1
          names = (x.branch_name for x in project.branches)
          butTellAlsoThis = "How about #{tellEitherOneOfThese names} instead?"
        else
          butTellAlsoThis = "Do you mean \"#{project.branches[0].branch_name}\" perhaps? :wink:"

        msg.reply "I don't know anything about \"#{branchName}\" branch. Sorry. :cry: #{butTellAlsoThis}"
        return

      msg.reply statusMessage branch

  robot.router.post "/hubot/semaphoreapp", (req, res) ->
    unless process.env.HUBOT_SEMAPHOREAPP_NOTIFY_RULES
      message = "semaphoreapp hook warning: HUBOT_SEMAPHOREAPP_NOTIFY_RULES is empty."
      res.send(500, { error: message })
      console.log message
      return

    try
      payload = req.body
    catch error
      message = "semaphoreapp hook error: #{error}. Payload: #{req.body}"
      res.send(400, message)
      console.log message
      return

    res.send()

    rules = process.env.HUBOT_SEMAPHOREAPP_NOTIFY_RULES.split(',')
    for rule in (x.split(':') for x in rules)
      room = rule[0]
      branch = rule[1]

      try
        branchRegExp = new RegExp("^#{branch}$" if branch)
      catch error
        console.log "semaphoreapp error: #{error}."
        return

      if branchRegExp.test(payload.branch_name)
        robot.messageRoom room, statusMessage payload

tellEitherOneOfThese = (things) ->
  "\"#{things[...-1].join('\", \"')}\" or \"#{things[-1..]}\""

statusEmoji = (status) ->
  switch status
    when "passed" then ":white_check_mark:"
    when "failed" then ":x:"
    when "pending" then ":warning:"

statusMessage = (branch) ->
  refSpec = "#{branch.project_name}/#{branch.branch_name}"
  result = "#{branch.result[0].toUpperCase() + branch.result[1..-1].toLowerCase()}"
  message = if branch.commit then " \"#{branch.commit.message.split(/\n/)[0]}\"" else ""
  authorName = if branch.commit then " - #{branch.commit.author_name}" else ""
  buildURL = "#{branch.build_url}"
  "#{statusEmoji branch.result} [#{refSpec}] #{result}:#{message}#{authorName} (#{buildURL})"

class SemaphoreApp
  constructor: (msg) ->
    @msg = msg

  getListOfAllProjects: (callback) ->
    unless process.env.HUBOT_SEMAPHOREAPP_AUTH_TOKEN
      @msg.reply "I am not allowed to access Semaphore APIs, sorry. :cry:"
      return

    @msg.robot.http("https://semaphoreapp.com/api/v1/projects")
      .query(auth_token: "#{process.env.HUBOT_SEMAPHOREAPP_AUTH_TOKEN}")
      .get() (err, res, body) ->
        try
          json = JSON.parse body
        catch error
          console.log "semaphoreapp error: #{error}."
          @msg.reply "Semaphore is talking gibberish right now. Try again later?! :confused:"

        callback json
