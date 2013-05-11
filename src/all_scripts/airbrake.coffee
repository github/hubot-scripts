# Description:
#   None
#
# Dependencies:
#   "jsdom": "0.2.14"
#
# Configuration:
#   HUBOT_AIRBRAKE_AUTH_TOKEN
#   HUBOT_AIRBRAKE_PROJECT
#
# Commands:
#   hubot show me airbrake errors - Get the most recent active errors
#
# Author:
#   tommeier

jsdom = require 'jsdom'
env = process.env

module.exports = (robot) ->

  robot.respond /(show me )?airbrake( errors)?(.*)/i, (msg) ->
    query msg, (body, err, project_name) ->
      return msg.send err if err

      error_groups = body.getElementsByTagName("group")
      return msg.send "Congrats! No errors in the system right now!" unless error_groups?

      output = "#{error_groups.length} recent errors found :"

      for group in error_groups
        most_recent_at = group.getElementsByTagName("most-recent-notice-at")[0].innerHTML
        created_at    = group.getElementsByTagName("created-at")[0].innerHTML
        updated_at    = group.getElementsByTagName("updated-at")[0].innerHTML
        notices_count = group.getElementsByTagName("notices-count")[0].innerHTML

        error_id      = group.getElementsByTagName("id")[0].innerHTML
        error_class   = group.getElementsByTagName("error-class")[0].innerHTML
        error_message = group.getElementsByTagName("error-message")[0].innerHTML
        resolved      = group.getElementsByTagName("resolved")[0].innerHTML

        file          = group.getElementsByTagName("file")[0].innerHTML
        rails_env     = group.getElementsByTagName("rails-env")[0].innerHTML
        line_number   = group.getElementsByTagName("line-number")[0].innerHTML

        error_url     = "https://#{project_name}.airbrakeapp.com/errors/#{error_id}"

        output += "\n****"
        output += "\n* ##{error_id}(#{notices_count}) : Last error @ #{most_recent_at}"
        output += "\n* #{rails_env} - #{error_class} : #{error_message}"
        output += "\n* #{error_url} => #{file}:#{line_number}"

      msg.send output
      msg.send "\n****"


  getDom = (xml) ->
    body = jsdom.jsdom(xml)
    throw Error("No XML data returned.") if body.getElementsByTagName("group")[0].childNodes.length == 0
    body

  query = (msg, cb) ->
    airbrake_auth_key = process.env.HUBOT_AIRBRAKE_AUTH_TOKEN
    airbrake_project  = process.env.HUBOT_AIRBRAKE_PROJECT

    unless airbrake_auth_key
       msg.send "Airbrake auth token isn't set. Sign up at http://airbrakeapp.com"
       msg.send "Then set the HUBOT_AIRBRAKE_AUTH_TOKEN environment variable"
       return

    unless airbrake_project
       msg.send "Airbrakeproject isn't set. Sign up at http://airbrakeapp.com. Your project name is : http://<project_name>.airbrakeapp.com ."
       msg.send "Then set the HUBOT_AIRBRAKE_PROJECT environment variable"
       return

    msg.http("https://#{airbrake_project}.airbrake.io/errors.xml")
      .query(auth_token: airbrake_auth_key)
      .get() (err, res, body) ->
        try
          body = getDom body
        catch err
          err = "Could not fetch airbrake errors."
        cb(body, err, airbrake_project)
