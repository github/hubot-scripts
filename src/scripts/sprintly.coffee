# List stories and other items in Sprint.ly and interact with them.
#
# sprintly [product_id] [status] [limit] - list items in status (default status is in-progress, other values: backlog, completed, accepted; default limit is 20)
# sprintly [product_id] mine - list items assigned to me
# sprintly [product_id] #42 - show item number 42
# sprintly token <email:apitoken> - set/update credentials for user (required for other commands to work)
# sprintly default 1234 - set default product_id
#

module.exports = (robot) ->

  sprintlyUser = (msg) ->
    robot.brain.data.sprintly ?= {}
    robot.brain.data.sprintly[msg.message.user.id] ?= {}

  sprintly = (msg, auth) ->
    if auth ?= sprintlyUser(msg).auth
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
          sprintlyUser(msg).auth = msg.match[1]
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

  robot.respond /sprintly +(?:(\d+) +)?mine *$/, (msg) ->
    client = sprintly(msg).product()
    user = sprintlyUser(msg)

    listMine = -> client.scope('items.json').query(assigned_to: user.user_id).get()(formatItems(msg))

    if user.user_id
      listMine()
    else
      client.scope('people.json').get() (err, res, body) ->
        if res.statusCode == 200
          payload = JSON.parse(body)
          user_email = user.auth.split(':')[0]
          for {id, email} in payload when email == user_email
            user.user_id = id
            listMine()
            break
        else
          msg.send "Something came up: #{body}"

  robot.respond /sprintly +(?:(\d+) +)?#(\d+) *$/, (msg) ->
    sprintly(msg).product()
      .scope("items/#{msg.match[2]}.json")
      .get() (err, res, body) ->
        if res.statusCode == 200
          item = JSON.parse(body)
          msg.send itemSummary(item)
          msg.send item.description
          meta = [
            "status: #{item.status}"
            "assigned_to: #{if u = item.assigned_to then "#{u.first_name} #{u.last_name}" else "nobody"}"
            "created by: #{item.created_by.first_name} #{item.created_by.last_name}"
          ]
          meta.push "tags: #{item.tags.join(", ")}" if item.tags and item.tags.length > 0
          msg.send meta.join(", ")
        else
          msg.send "Something came up: #{body}"

DummyClient = ->
self = -> this
for method in ['scope', 'query', 'product']
  DummyClient::[method] = self
for method in ['get', 'post', 'put', 'delete']
  DummyClient::[method] = -> self

itemSummary = (item) ->
  summary = "##{item.number} (#{item.score}) "
  summary += "#{item.type}: " if item.type isnt 'story'
  summary += item.title
  summary += " https://sprint.ly/#!/product/#{item.product.id}/item/#{item.number}"
  summary

formatItems = (msg) ->
  (err, res, body) ->
    if res.statusCode == 200
      payload = JSON.parse(body)
      for item in payload
        msg.send itemSummary(item)
    else
      msg.send "Something came up: #{body}"
