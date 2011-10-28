# Basic SendGrid statistics.
#
# Set HUBOT_SENDGRID_USER to your SendGrid username (the same as you use to log in to sendgrid.com)
# Set HUBOT_SENDGRID_KEY to your SendGrid password (the same as you use to log in to sendgrid.com)
#
# sendgrid total - total sendgrid usage for the account
# sendgrid today - Total usage for today
# sendgrid c[ategory] <category> - Today's usage for the given category

env = process.env
  
module.exports = (robot) ->
  if env.HUBOT_SENDGRID_USER and env.HUBOT_SENDGRID_KEY
    robot.respond /(sendgrid)( me)? today/i, (msg) ->
      opts =
        days: 0
      query msg, opts, (json) ->
        msg.send formatResponse(json[0])

    robot.respond /(sendgrid)( me)? total/i, (msg) ->
      opts =
        aggregate: 1
      query msg, opts, (json) ->
        msg.send formatResponse(json)

    robot.respond /(sendgrid)( me)? c(ategory)? (.*)/i, (msg) ->
      category = msg.match[4]
      msg.send "Category: #{category}"
      opts =
        days: 0
        category: [category] 
      query msg, opts, (json) ->
        msg.send formatResponse(json[0])
  
query = (msg, opts, callback) ->
  opts.api_user = env.HUBOT_SENDGRID_USER
  opts.api_key = env.HUBOT_SENDGRID_KEY
  msg.http("https://sendgrid.com/api/stats.get.json")
    .query(opts)
    .get() (err, res, body) ->
      callback JSON.parse(body)

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

formatResponse = (json) =>
  details = for stat, description of stats
    "  #{description}: #{json[stat]}"
  details.unshift "Stats for #{json.date}:"
  details.join("\n")