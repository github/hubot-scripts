# Description:
#   Allows Hubot to interact with Harvest's (http://harvestapp.com) time-tracking
#   service.
#
# Dependencies:
#   None
# Configuration:
#   HUBOT_HARVEST_SUBDOMAIN
#     The subdomain you access the Harvest service with, e.g.
#     if you have the Harvest URL http://yourcompany.harvestapp.com
#     you should set this to "yourcompany" (without the quotes).
#
# Commands:
#   hubot remember my harvest account <email> with password <password> - Saves your Harvest credentials to allow Hubot to track time for you
#   hubot forget my harvest account - Deletes your account credentials from Hubot's memory
#   hubot start harvest at <project>: notes - TODO
#   hubot finish harvest at <project> - TODO
#   hubot daily harvest [of <user>] - Hubot responds with your/a specific user's entries for today
# 
# Author:
#   Quintus

module.exports = (robot) ->

  # Provide facility for saving the account credentials.
  robot.respond /remember my harvest account (.+) with password (.+)/i, (msg) ->
    account = new HarvestAccount msg.match[1], msg.match[2]

    # If the credentials are valid, remember them, otherwise
    # tell the user they are wrong.
    account.test msg, (valid) ->
      if valid
        msg.message.user.harvest_account = account
        msg.reply "Thanks, I'll remember your credentials. Have fun with Harvest."
      else
        msg.reply "Uh-oh -- I just tested your credentials, but they appear to be wrong. Please specify the correct ones."

  # Allows a user to delete his credentials.
  robot.respond /forget my harvest account/i, (msg) ->
    msg.message.user.harvest_account = null
    msg.reply "Okay, I erased your credentials from my memory."

  # Retrieve your or a specific user's timesheet for today.
  robot.respond /daily harvest( of (.+))?/i, (msg) ->
    # Detect the user; if none is passed, assume the sender.
    if msg.match[2]
      user = robot.userForName(msg.match[2])
      unless user
        msg.reply "#{msg.match[2]}? Who's that?"
        return
    else
      user = msg.message.user

    # Check if we know the detected user's credentials.
    unless user.harvest_account
      if user == msg.message.user
        msg.reply "You have to tell me your Harvest credentials first."
      else
        msg.reply "I didn't crack #{user.name}'s Harvest credentials yet, but I'm working on it... Sorry for the inconvenience."
      return

    user.harvest_account.daily msg, (status, body) ->
      if 200 <= status <= 299
        msg.reply "Your entries for today, #{user.name}:"
        for entry in body.day_entries
          if entry.ended_at == ""
            msg.reply "* #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [running since #{entry.started_at} (#{entry.hours}h)]"
          else
            msg.reply "* #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [#{entry.started_at} - #{entry.ended_at} (#{entry.hours}h)]"
      else
        msg.reply "Request failed with status #{status}."

# Class managing the Harvest account associated with
# a user. Keeps track of the user's credentials and can
# be used to query the Harvest API on behalf of that user.
#
# The API calls are asynchronous, i.e. the methods executing
# the request immediately return. To process the response,
# you have to attach a callback to the method call, which
# unless documtened otherwise will receive two arguments,
# the first being the response's status code, the second
# one is the response's body as a JavaScript object created
# via `JSON.parse`.
class HarvestAccount

  constructor: (email, password) ->
    @base_url = "https://#{process.env.HUBOT_HARVEST_SUBDOMAIN}.harvestapp.com"
    @email    = email
    @password = password

  # Tests whether the account credentials are valid.
  # If so, the callback gets passed `true`, otherwise
  # it gets passed `false`.
  test: (msg, callback) ->
   this.request(msg).path("account/who_am_i").get() (err, res, body) ->
      if 200 <= res.statusCode <= 299
        callback true
      else
        callback false

  # Issues /daily to the Harvest API.
  daily: (msg, callback) ->
    this.request(msg).path("daily").get() (err, res, body) ->
      callback res.statusCode, JSON.parse(body)

  # (internal method)
  # Assembles the basic parts of a request to the Harvest
  # API, i.e. the Content-Type/Accept and authorization
  # headers. The returned HTTPClient object can (and should)
  # be customized further by calling path() and other methods
  # on it.
  request: (msg) ->
    req = msg.http(@base_url).headers
      "Content-Type": "application/json"
      "Accept": "application/json"
    .auth(@email, @password)
    return req
