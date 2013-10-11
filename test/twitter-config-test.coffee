expect = require "expect.js"
preConfig = require "../src/twitter-config"

describe "twitter-config", ->
  describe ".defaultCredentials()", ->
    it "throws an error without any variables specified", ->
      config = preConfig({})
      expect(config.defaultCredentials).to.throwException()

    it "uses the first credentials it specifies", ->
      config = preConfig({
        HUBOT_TWITTER_CONSUMER_KEY: 'consumerkey'
        HUBOT_TWITTER_CONSUMER_SECRET: 'consumersecret'
        HUBOT_TWITTER_ACCESS_TOKEN_KEY_FOO: 'fookey'
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET_FOO: 'foosecret'
      })
      expect(config.defaultCredentials()).to.eql({
        consumer_key: 'consumerkey'
        consumer_secret: 'consumersecret'
        access_token: 'fookey'
        access_token_key: 'fookey'
        access_token_secret: 'foosecret'
      })

  describe ".credentialsFor()", ->
    it "returns undefined without any variables specified", ->
      config = preConfig({})
      expect(config.credentialsFor('foo')).to.eql(undefined)

    it "only returns credentials when the key is present", ->
      config = preConfig({
        HUBOT_TWITTER_CONSUMER_KEY: 'consumerkey'
        HUBOT_TWITTER_CONSUMER_SECRET: 'consumersecret'
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET_FOO: 'foosecret'
      })
      expect(config.credentialsFor('foo')).to.eql(undefined)

    it "only returns credentials when the secret is present", ->
      config = preConfig({
        HUBOT_TWITTER_CONSUMER_KEY: 'consumerkey'
        HUBOT_TWITTER_CONSUMER_SECRET: 'consumersecret'
        HUBOT_TWITTER_ACCESS_TOKEN_KEY_FOO: 'fookey'
      })
      expect(config.credentialsFor('foo')).to.eql(undefined)

    it "is case-insensitive", ->
      config = preConfig({
        HUBOT_TWITTER_CONSUMER_KEY: 'consumerkey'
        HUBOT_TWITTER_CONSUMER_SECRET: 'consumersecret'
        HUBOT_TWITTER_ACCESS_TOKEN_KEY_FOO: 'fookey'
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET_FOO: 'foosecret'
      })
      expect(config.credentialsFor('Foo')).to.eql({
        consumer_key: 'consumerkey'
        consumer_secret: 'consumersecret'
        access_token: 'fookey'
        access_token_key: 'fookey'
        access_token_secret: 'foosecret'
      })

    it "returns the matching credentials", ->
      config = preConfig({
        HUBOT_TWITTER_CONSUMER_KEY: 'consumerkey'
        HUBOT_TWITTER_CONSUMER_SECRET: 'consumersecret'
        HUBOT_TWITTER_ACCESS_TOKEN_KEY_FOO: 'fookey'
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET_FOO: 'foosecret'
        HUBOT_TWITTER_ACCESS_TOKEN_KEY_BAR: 'barkey'
        HUBOT_TWITTER_ACCESS_TOKEN_SECRET_BAR: 'barsecret'
      })
      expect(config.credentialsFor('foo')).to.eql({
        consumer_key: 'consumerkey'
        consumer_secret: 'consumersecret'
        access_token: 'fookey'
        access_token_key: 'fookey'
        access_token_secret: 'foosecret'
      })
      expect(config.credentialsFor('bar')).to.eql({
        consumer_key: 'consumerkey'
        consumer_secret: 'consumersecret'
        access_token: 'barkey'
        access_token_key: 'barkey'
        access_token_secret: 'barsecret'
      })
