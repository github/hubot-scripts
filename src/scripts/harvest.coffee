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
#   hubot forget my harvest account <email> - Deletes your account credentials from Hubot's memory
#   hubot start harvest at <project>: notes - TODO
#   hubot finish harvest at <project> - TODO
#   hubot daily harvest - Hubot responds with your entries for today
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
  robot.respond /forget my harvest account (.+)/i, (msg) ->
    msg.message.user.harvest_account = null
    msg.reply "Okay, I erased your credentials from my memory."

  robot.respond /daily harvest/i, (msg) ->
    msg.message.user.harvest_account.daily msg, (status, body) ->
      if 200 <= status <= 299
        msg.reply "Your entries for today, #{msg.message.user.name}:"
        for entry in body.day_entries
          if entry.ended_at == ""
            msg.reply "* #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [running since #{entry.started_at} (#{entry.hours}h)]"
          else
            msg.reply "* #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [#{entry.started_at} - #{entry.ended_at} (#{entry.hours}h)]"
      else
        msg.reply "Failed with status #{status}."

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
