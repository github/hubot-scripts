# Description:
#   Shared module for reading Twitter configuration from envionment variables.
#   One HUBOT_TWITTER_ACCESS_TOKEN_KEY_* and HUBOT_TWITTER_ACCESS_TOKEN_SECRET_*
#   pair should be set per account you want to connect.
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME1>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME1>
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME2>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME2>
#   ...
#
# Author:
#   afeld

defaultHandle = undefined
credentials = {}

consumerKey = process.env.HUBOT_TWITTER_CONSUMER_KEY
consumerSecret = process.env.HUBOT_TWITTER_CONSUMER_SECRET

unless consumerKey
  console.log "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
unless consumerSecret
  console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."

ENV_REGEX = /^HUBOT_TWITTER_ACCESS_TOKEN_KEY_(\w+)$/

# populate the credentials
for envVar of process.env
  match = envVar.match(ENV_REGEX)
  if match
    capsHandle = match[1]
    secret = process.env["HUBOT_TWITTER_ACCESS_TOKEN_SECRET_#{capsHandle}"]
    # secret corresponding to the provided key must be set
    if secret
      handle = capsHandle.toLowerCase()
      defaultHandle ||= handle

      key = process.env["HUBOT_TWITTER_ACCESS_TOKEN_KEY_#{capsHandle}"]
      credentials[handle] = {
        consumer_key: consumerKey
        consumer_secret: consumerSecret
        access_token: key # for twit
        access_token_key: key # for ntwitter
        access_token_secret: secret
      }
    else
      console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET_#{capsHandle} environment variable."


module.exports = {
  credentialsFor: (handle) ->
    if handle
      credentials[handle.toLowerCase()]
    else
      throw new Error("No 'handle' provided.")

  defaultHandle: ->
    defaultHandle

  defaultCredentials: ->
    @credentialsFor(defaultHandle)
}
