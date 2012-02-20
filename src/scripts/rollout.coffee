# Rollout REST API interface.
#
# Requires rollout_rest_api endpoint configured in the HUBOT_ROLLOUT_API_URL env var.
#
# Get rollout_rest_api here: https://github.com/jamesgolick/rollout_rest_api
#
# rollout list - Returns a list of available features.
# rollout show <feature> - Shows the current rollout of `feature`.
# rollout activate_user <feature> <user_id> - Activate `feature` for `user_id`.
# rollout deactivate_user <feature> <user_id> - Deactivate `feature` for `user_id`.
# rollout activate_group <feature> <group> - Activate `feature` for `group_id`.
# rollout deactivate_group <feature> <group> - Deactivate `feature` for `group_id`.
# rollout activate_percentage <feature> <percentage> - Activate `feature` for `percentage`% of users.
# rollout deactivate <feature> - Deactivate `feature` all users.

endpoint = process.env.HUBOT_ROLLOUT_API_URL + '/'

show = (msg, feature) ->
  msg.http(endpoint + feature + '.json').get() (err, res, body) ->
    msg.send body

module.exports = (robot) ->
  robot.respond /rollout list$/i, (msg) ->
    msg.http(endpoint + 'features.json').get() (err, res, body) ->
      json = JSON.parse(body)
      msg.send json.sort().join("\n")

  robot.respond /rollout show (.*)/i, (msg) ->
    show(msg, msg.match[1])

  robot.respond /rollout activate_user ([^\s]*) ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1] + '/users').query(user: msg.match[2]).put() (err, res, body) ->
      show(msg, msg.match[1])

  robot.respond /rollout deactivate_user ([^\s]*) ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1] + '/users').query({user: msg.match[2]}).delete() (err, res, body) ->
      show(msg, msg.match[1])

  robot.respond /rollout activate_group ([^\s]*) ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1] + '/groups').query(group: msg.match[2]).put() (err, res, body) ->
      show(msg, msg.match[1])

  robot.respond /rollout deactivate_group ([^\s]*) ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1] + '/groups').query({group: msg.match[2]}).delete() (err, res, body) ->
      show(msg, msg.match[1])

  robot.respond /rollout activate_percentage ([^\s]*) ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1] + '/percentage').query(percentage: msg.match[2]).put() (err, res, body) ->
      show(msg, msg.match[1])

  robot.respond /rollout deactivate ([^\s]*)/i, (msg) ->
    msg.http(endpoint + msg.match[1]).delete() (err, res, body) ->
      msg.send("[DONE]")
