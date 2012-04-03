# Index chat logs in Apache Solr
#
# You can set the following variables:
#   HUBOT_SOLR_HOST = "127.0.0.1"
#   HUBOT_SOLR_PORT = "8983"
#   HUBOT_SOLR_CORE = "/hubot"
#   HUBOT_SOLR_PATH = "/solr"
#

solr = require 'solr'
crypto = require 'crypto'

module.exports = (robot) ->
  # See node-solr/lib/solr.js for info about the options.
  options =
    host: if process.env.HUBOT_SOLR_HOST then process.env.HUBOT_SOLR_HOST else '127.0.0.1'
    port: if process.env.HUBOT_SOLR_PORT then process.env.HUBOT_SOLR_PORT else '8983'
    core: if process.env.HUBOT_SOLR_CORE then process.env.HUBOT_SOLR_CORE else ''
    path: if process.env.HUBOT_SOLR_PATH then process.env.HUBOT_SOLR_PATH else '/solr'

  client = solr.createClient(options)
  robot.hear /./, (msg) ->
    id = crypto.createHash('md5')
      .update(
        Date.now +
        msg.message.user.room +
        msg.message.user.name +
        msg.message.text,
        'utf8'
      )
      .digest('hex')
    doc =
      id: id
      channel_t: msg.message.user.room
      nick_t: msg.message.user.name
      message_t: msg.message.text
    client.add doc, (err) ->
      if err
        console.error err
        return
      client.commit (err) ->
        if err
          console.error err
          return

