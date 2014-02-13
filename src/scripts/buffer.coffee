# Description:
#   Post to Buffer. Support for multiple profiles and fuzzy search.
#
# Dependencies:
#   "buffer-alpaca": "~0.1.0"
#   "lodash-node": "~2.4.1"
#
# Configuration:
#   BUFFER_ACCESS_TOKEN - Access token for Buffer API.
#
# Commands:
#   hubot buffer <account> <message> - Buffer a new message for the account.
#   hubot buffered <account> - List amount of buffered items for an account.
#   hubot buffer_profiles - List the Buffer profiles for this account.
#
# Author:
#   Jeremy Mack (@mutewinter)

_ = require 'lodash-node'
buffer = require 'buffer-alpaca'

client = buffer.client(process.env.BUFFER_ACCESS_TOKEN)
user = client.user()

sanitizeAccount = (account) ->
  account.replace(/^@/, '')

bufferProfile = (account, callback) ->
  account = sanitizeAccount(account)
  user.profiles (err, response) ->
    profiles = response.body

    profile = _.find profiles,  (profile) ->
      profile.service_username.toLowerCase() is account.toLowerCase()

    callback(profile)

buffer = (msg, account, text) ->
  bufferProfile account, (profile) ->
    if profile
      messageUser = msg.message.user.name
      attributedText = "#{text} ^#{messageUser}"
      user.createUpdate(attributedText, [profile.id], (err, response) ->
        if err
          msg.reply 'Buffer API Error. Post not buffered.'
        else
          serviceUsername = profile.service_username
          msg.reply ":sparkles: Buffered #{text} for #{serviceUsername}"
      )
    else
      msg.reply "Profile '#{account}' not found."


profiles = (msg) ->
  user.profiles (err, response) ->
    profiles = response.body
    usernames = _.map(profiles, 'service_username')
    msg.reply "Buffer Profiles: #{usernames.join(', ')}"
    msg.reply 'Buffer a post with the /buffer command.'

buffered = (msg, account) ->
  bufferProfile account, (profile) ->
    if profile
      client.profile(profile.id).pending (err, response) ->
        if err
          msg.reply 'Buffer API Error. No posts found.'
        else
          json = response.body
          username = profile.service_username
          postsText = if json.total is 1 then 'post' else 'posts'
          msg.reply "#{json.total} pending #{postsText} for #{username}"
    else
      msg.reply "Profile '#{account}' not found."

module.exports = (robot) ->
  robot.respond /buffer (\w*)\s?(.*)/i, (msg) ->
    account = msg.match[1]
    text = msg.match[2]

    if account and text
      buffer(msg, account, text)
    else
      msg.reply 'Must specify an account. E.g. /buffer hearsparkbox Slim Squid'

  robot.respond /buffered (\w*)/i, (msg) ->
    account = msg.match[1]

    if account
      buffered(msg, account)
    else
      msg.reply 'Must specify an account. E.g. /buffered hearsparkbox'

  robot.respond /buffer_profiles/i, (msg) ->
    profiles(msg)
