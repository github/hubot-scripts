# List stories and other items in Sprint.ly and interact with them.
#
# sprintly [product_id] [status] [limit] - list items in status (default status is in-progress, other values: backlog, completed, accepted; default limit is 20)
# sprintly token <email:apitoken> - set/update credentials for user (required for other commands to work)
# sprintly default 1234 - set default product_id
#

module.exports = (robot) ->

  sprintly = (msg, auth) ->
    if auth ?= robot.brain.data.sprintly?[msg.message.user.id]
      client = msg.http('https://sprint.ly')
        .header('accept', 'application/json')
        .header('authorization', "Basic #{new Buffer(auth).toString('base64')}")
        .path('/api')
      client.product = ->
        if product_id = msg.match[1] ? robot.brain.data.sprintly?.product_id
          @path("/api/products/#{product_id}")
        else
          msg.send "No Product Id has been specified, you can set a default with 'sprintly default 1234'"
          new DummyClient()
      client
    else
      msg.send "API token not found, set it with 'sprintly token <email:apitoken>'"
      new DummyClient()

  robot.respond /sprintly +token +(.*)/i, (msg) ->
    sprintly(msg, msg.match[1])
      .scope('products.json')
      .get() (err, res, body) ->
        if res.statusCode < 400
          robot.brain.data.sprintly ?= {}
          robot.brain.data.sprintly[msg.message.user.id] = msg.match[1]
          msg.send "API token set"
        else
          msg.send "Unable to verify API token: #{body}"

  robot.respond /sprintly +default +(\d+) *$/, (msg) ->
    robot.brain.data.sprintly ?= {}
    robot.brain.data.sprintly.product_id = msg.match[1]
    msg.send "Default Product ID set to #{msg.match[1]}"

  robot.respond /sprintly *(?: +(\d+))?(?: +(backlog|in-progress|completed|accepted))?(?: +(\d+))? *$/, (msg) ->
    query = status: msg.match[2] ? 'in-progress'
    query.limit = msg.match[3] if msg.match[3]
    sprintly(msg).product()
      .scope('items.json')
      .query(query)
      .get()(formatItems(msg))

DummyClient = ->
self = -> this
for method in ['scope', 'query', 'product']
  DummyClient::[method] = self
for method in ['get', 'post', 'put', 'delete']
  DummyClient::[method] = -> self

formatItems = (msg) ->
  (err, res, body) ->
    if res.statusCode == 200
      payload = JSON.parse(body)
      items = payload.map (item) ->
        "##{item.number} #{item.score} #{if item.type isnt 'story' then "#{item.type}: " else ""}#{item.title} https://sprint.ly/#!/product/#{item.product.id}/item/#{item.number}"
      msg.send items.join("\n")
    else
      msg.send "Something came up: #{body}"
