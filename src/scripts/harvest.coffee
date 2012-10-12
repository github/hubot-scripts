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
#   hubot [I'm] harvesting on <project>: <notes> - Start time tracking for a project with the given notes
#   hubot [I've] finished on <project> - Stop time tracking on the given project
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

class HarvestAccount

  constructor: (email, password) ->
    @base_url = "https://#{process.env.HUBOT_HARVEST_SUBDOMAIN}.harvestapp.com"
    @email    = email
    @password = password

  # Asynchronously tests whether the account credentials are
  # valid. If so, the callback gets passed true, otherwise
  # it gets passed false.
  test: (msg, callback) ->
    msg.http(@base_url).headers
      "Content-Type": "application/json"
      "Accept": "application/json"
    .auth(@email, @password)
    .path("account/who_am_i").get() (err, res, body) ->
      if 200 <= res.statusCode <= 299
        callback true
      else
        callback false
