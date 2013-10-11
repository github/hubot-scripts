# Description:
#   Basic SendGrid statistics
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SENDGRID_USER to your SendGrid username (the same as you use to log in to sendgrid.com)
#   HUBOT_SENDGRID_KEY to your SendGrid password (the same as you use to log in to sendgrid.com)
#
# Commands:
#   hubot sendgrid total - total sendgrid usage for the account
#   hubot sendgrid today - Total usage for today
#   hubot sendgrid last X [days] - Total usage for the last X days
#   hubot sendgrid c[ategory] [total] <category> - Today or all time usage for the given category
#   hubot sendgrid c[ategory] last X [days] <category> - Total usage for the last X days for the given category
#   hubot sendgrid categories - list all categories for account
#
# Author:
#   sixfeetover
#   drdamour

env = process.env
  
module.exports = (robot) ->
  if env.HUBOT_SENDGRID_USER and env.HUBOT_SENDGRID_KEY
    robot.respond /(sendgrid)( me)? today/i, (msg) ->
      opts =
        start_date: getTodayStr
      query msg, opts, (json) ->
        msg.send formatResponse(json[0], json[0].date)

    robot.respond /(sendgrid)( me)? total/i, (msg) ->
      opts =
        aggregate: 1
      query msg, opts, (json) ->
        msg.send formatResponse(json, "All Time")

    robot.respond /(sendgrid)( me)? last (\d+)( days)?/i, (msg) ->
      opts =
        days: msg.match[3]
        aggregate: 1
      query msg, opts, (json) ->
        msg.send formatResponse(json, "Last #{opts.days} days")

    robot.respond /(sendgrid)( me)? c(ategory)?( total)? (.*)/i, (msg) ->
      category = msg.match[5].trim()
      match = /last (\d+)( days)?/i
      #this response matches the next respond, so we need to short circuit it
      #anyone got a better way?
      if match.test(category) 
        return
      isAllTime = msg.match[4] is " total"
      msg.send "Category: #{category}"
      opts =
        category: [category]

      if(isAllTime)
        opts.aggregate = 1
      else
        opts.days = 0
      query msg, opts, (json) ->
        if(isAllTime)
          #surprisingly when you set a cateogry, the aggregate is sent in an array
          msg.send formatResponse(json[0], "All Time")
        else
          msg.send formatResponse(json[0], json[0].date)

    robot.respond /(sendgrid)( me)? c(ategory)? last (\d+)( days)? (.*)/i, (msg) ->
      category = msg.match[6].trim()
      msg.send "Category: #{category}"
      opts =
        category: [category]
        aggregate: 1
        days: msg.match[4]
      query msg, opts, (json) ->
        #surprisingly when you set a cateogry, the aggregate is sent in an array
        msg.send formatResponse(json[0], "Last #{opts.days} days")
          

    robot.respond /(sendgrid)( me)? categories/i, (msg) ->
      opts =
        list: "true"
      query msg, opts, (json) ->
        msg.send json[0].category
        categories = for cat in json
          "  #{cat.category}"
        msg.send categories.join('\n')
  
query = (msg, opts, callback) ->
  opts.api_user = env.HUBOT_SENDGRID_USER
  opts.api_key = env.HUBOT_SENDGRID_KEY
  msg.http("https://sendgrid.com/api/stats.get.json")
    .query(opts)
    .get() (err, res, body) ->
      parsedBody = JSON.parse(body)
      if parsedBody.error
        msg.send parsedBody.error
        return
      callback parsedBody

stats =
  requests: 'Requests'
  delivered: 'Delivered'

  bounces: 'Bounces'
  repeat_bounces: 'Repeat Bounces'
  
  invalid_email: 'Invalid Emails'
  
  opens: 'Opens'
  unique_opens: 'Unique Opens'
  
  clicks: 'Clicks'
  unique_clicks: 'Unique Clicks'
  
  unsubscribes: 'Unsubscribes'
  repeat_unsubscribes: 'Repeat Unsubscribes'
  
  blocked: 'Blocked'
  spam_drop: 'Spam Drop'
  
  spamreports: 'Spam Reports'
  repeat_spamreports: 'Repeat Spam Reports'

formatResponse = (json, header) =>
  details = for stat, description of stats
    "  #{description}: #{json[stat]}"
  details.unshift "Stats for #{header}:"
  details.join("\n")

getTodayStr = () =>
  today = new Date();
  cur_day = today.getDate()
  cur_month = today.getMonth() + 1
  cur_year = today.getFullYear()
  tdy_string = cur_year + "-" + cur_month + "-" + cur_day
