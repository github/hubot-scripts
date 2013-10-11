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

module.exports = (env) ->
  defaultHandle = undefined
  credentials = {}
  defaultCredentials = undefined

  consumerKey = env.HUBOT_TWITTER_CONSUMER_KEY
  consumerSecret = env.HUBOT_TWITTER_CONSUMER_SECRET
  # for backwards compatability
  # https://github.com/github/hubot-scripts/pull/1179#issuecomment-26058780
  defaultTokenKey = env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
  defaultTokenSecret = env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

  createCredentials = (tokenKey, tokenSecret) ->
    {
      consumer_key: consumerKey
      consumer_secret: consumerSecret
      access_token: tokenKey # for twit
      access_token_key: tokenKey # for ntwitter
      access_token_secret: tokenSecret
    }

  if defaultTokenKey and defaultTokenSecret
    defaultCredentials = createCredentials(defaultTokenKey, defaultTokenSecret)

  unless consumerKey
    console.log "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
  unless consumerSecret
    console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."

  ENV_REGEX = /^HUBOT_TWITTER_ACCESS_TOKEN_KEY_(\w+)$/

  # populate the credentials
  for envVar of env
    match = envVar.match(ENV_REGEX)
    if match
      capsHandle = match[1]
      secret = env["HUBOT_TWITTER_ACCESS_TOKEN_SECRET_#{capsHandle}"]
      # secret corresponding to the provided key must be set
      if secret
        handle = capsHandle.toLowerCase()
        defaultHandle ||= handle

        key = env["HUBOT_TWITTER_ACCESS_TOKEN_KEY_#{capsHandle}"]
        credentials[handle] = createCredentials(key, secret)
      else
        console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET_#{capsHandle} environment variable."

  {
    credentialsFor: (handle) ->
      if handle
        credentials[handle.toLowerCase()]
      else
        throw new Error("No 'handle' provided.")

    defaultHandle: ->
      defaultHandle

    defaultCredentials: ->
      defaultCredentials or @credentialsFor(defaultHandle)
  }
