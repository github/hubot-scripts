# Description:
#   Can output total amount in your sales pipeline, as specified in a
#   report from SugarCRM
# 
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SUGARCRM_URL
#   HUBOT_SUGARCRM_USERNAME
#   HUBOT_SUGARCRM_PASSWORD
#   HUBOT_SUGARCRM_REPORT_ID
#   HUBOT_SUGARCRM_REPORT_FIELD
#
# Commands:
#   hubot pipeline me - Gives the total amount in sales pipeline
#
# Author:
#   skalnik

module.exports = (robot) ->
  robot.respond /pipeline( me)?/i, (msg) ->
    url          = process.env.HUBOT_SUGARCRM_URL
    username     = process.env.HUBOT_SUGARCRM_USERNAME
    password     = process.env.HUBOT_SUGARCRM_PASSWORD
    reportID     = process.env.HUBOT_SUGARCRM_REPORT_ID
    reportField  = process.env.HUBOT_SUGARCRM_REPORT_FIELD

    unless url
      msg.send "SugarCRM URL isn't set."
      msg.send "Please set the HUBOT_SUGARCRM_URL environment variable without prefixed HTTP or trailing slash"
      return

    unless username
      msg.send "SugarCRM username isn't set."
      msg.send "Please set the HUBOT_SUGARCRM_USERNAME environment variable"
      return

    unless password
      msg.send "SugarCRM password isn't set."
      msg.send "Please set the HUBOT_SUGARCRM_PASSWORD environment variable"
      return

    unless reportID
      msg.send "SugarCRM report ID is not set."
      msg.send "Please set the HUBOT_SUGARCRM_REPORT_ID to the report ID of your pipeline report"
      return

    unless reportField
      msg.send "SugarCRM report field is not set."
      msg.send "Please set the HUBOT_SUGARCRM_REPORT_FIELD to the field of the report that should be totaled"
      return

    sugarCRMLogin msg, url, username, password, (session) ->
      data = {
        session: session,
        ids: [reportID]
      }
      sugarCRMCall msg, url, 'get_report_entries', data, (err, res, body) ->
        json          = JSON.parse(body)
        entries       = json.entry_list[0]
        fields        = json.field_list[0]
        fieldID       = -1
        pipelineTotal = 0

        for i in [0...fields.length]
          fieldID = i if fields[i].name == reportField

        if fieldID == -1
          msg.send "Could not find " + reportField + " in the report fields."
          msg.send "Please double check HUBOT_SUGARCRM_REPORT_FIELD."
          return

        for entry in entries
          if entry.id
            amount = (entry.name_value_list.filter (field) -> field.name == fieldID)[0]
            pipelineTotal += parseInt(amount.value.replace(',', ''))

        msg.send "Total: $" + pipelineTotal

sugarCRMLogin = (msg, url, user_name, password, callback) ->
  crypto = require('crypto')
  hashedPassword = crypto.createHash('md5').update(password).digest("hex")
  data = {
    user_auth: {
      user_name: user_name,
      password: hashedPassword
    }
  }
  sugarCRMCall msg, url, 'login', data, (err, res, body) ->
    sessionID = JSON.parse(body).id
    callback(sessionID)

sugarCRMCall = (msg, url, method, data, callback) ->
  msg.http('https://' + url + '/service/v4/rest.php')
    .header('Content-Length', 0)
    .query
      method: method,
      input_type: 'JSON',
      response_type: 'JSON',
      rest_data: JSON.stringify data
    .post() (err, res, body) ->
      callback(err, res, body)
