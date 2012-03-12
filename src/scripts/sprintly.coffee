# List stories and other items in Sprint.ly and interact with them.
#
# sprintly [product_id] [status] [limit] - list items in status (default status is in-progress, other values: backlog, completed, accepted; default limit is 20)
# sprintly [product_id] mine - list items assigned to me
# sprintly [product_id] #42 - show item #42
# sprintly [product_id] #42 tasks - list unfinished subtasks of story #42
# sprintly [product_id] <action> #42 - carry out action on item #42 (available actions: start, stop, finish, accept, reject, delete)
# sprintly token <email:apitoken> - set/update credentials for user (required for other commands to work)
# sprintly default 1234 - set default product_id
#

qs = require 'querystring'

module.exports = (robot) ->

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
    withUserId msg, (user_id) ->
      sprintly(msg).product()
        .scope('items.json')
        .query(assigned_to: user_id)
        .get()(formatItems(msg))

  robot.respond /sprintly +(?:(\d+) +)?#(\d+) *$/, (msg) ->
    sprintly(msg).product()
      .scope("items/#{msg.match[2]}.json")
      .get() (err, res, body) ->
        if res.statusCode == 200
          item = JSON.parse(body)
          msg.send itemSummary(item)
          msg.send item.description if item.description
          meta = [
            "status: #{item.status}"
            "assigned_to: #{if u = item.assigned_to then "#{u.first_name} #{u.last_name}" else "nobody"}"
            "created by: #{item.created_by.first_name} #{item.created_by.last_name}"
          ]
          meta.push "tags: #{item.tags.join(", ")}" if item.tags and item.tags.length > 0
          msg.send meta.join(", ")
        else
          msg.send "Something came up: #{body}"

  robot.respond /sprintly +(?:(\d+) +)?#(\d+) +tasks *$/, (msg) ->
    sprintly(msg).product()
      .scope("items/#{msg.match[2]}/children.json")
      .get()(formatItems(msg, true))

  robot.respond /sprintly +(?:(\d+) +)?(start|stop|finish|accept|reject|delete) +#?(\d+) *$/, (msg) ->
    withUserId msg, (user_id) ->
      query = {}
      method = 'post'
      switch msg.match[2]
        when 'start'
          query.status = 'in-progress'
          query.assigned_to = user_id
        when 'stop'
          query.status = 'backlog'
        when 'finish'
          query.status = 'completed'
        when 'accept'
          query.status = 'accepted'
        when 'reject'
          query.status = 'in-progress'
        when 'delete'
          method = 'delete'
      sprintly(msg).product()
        .scope("items/#{msg.match[3]}.json")[method](qs.stringify(query)) (err, res, body) ->
          if res.statusCode < 400
            item = JSON.parse(body)
            if msg.match[2] is 'delete'
              msg.send "##{item.number} has been archived"
            else
              msg.send "##{item.number} status: #{item.status}"
          else
            msg.send "Something came up: #{body}"

DummyClient = ->
self = -> this
for method in ['scope', 'query', 'product']
  DummyClient::[method] = self
for method in ['get', 'post', 'put', 'delete']
  DummyClient::[method] = -> self

sprintlyUser = (msg) ->
  sp = msg.robot.brain.data.sprintly ?= {}
  sp[msg.message.user.id] ?= {}

sprintly = (msg, auth) ->
  if auth ?= sprintlyUser(msg).auth
    client = msg.http('https://sprint.ly')
      .header('accept', 'application/json')
      .header('authorization', "Basic #{new Buffer(auth).toString('base64')}")
      .path('/api')
    client.product = ->
      if product_id = msg.match[1] ? msg.robot.brain.data.sprintly?.product_id
        @path("/api/products/#{product_id}")
      else
        msg.send "No Product Id has been specified, you can set a default with 'sprintly default 1234'"
        new DummyClient()
    client
  else
    msg.send "API token not found, set it with 'sprintly token <email:apitoken>'"
    new DummyClient()

itemSummary = (item, subtask=false) ->
  parts = ["##{item.number}"]
  parts.push "(#{item.score})" unless subtask
  parts.push "#{item.type}:" if (not subtask and item.type isnt 'story') or (subtask and item.type isnt 'task')
  parts.push item.title
  parts.push "https://sprint.ly/#!/product/#{item.product.id}/item/#{item.number}"
  parts.join(" ")

formatItems = (msg, subtasks=false) ->
  no_items_msg = if subtasks then "No subtasks" else "No items"
  (err, res, body) ->
    if res.statusCode == 200
      payload = JSON.parse(body)
      if payload.length > 0
        for item in payload when not subtasks or item.status in ['backlog', 'in-progress']
          msg.send itemSummary(item, subtasks)
      else
        msg.send no_items_msg
    else
      msg.send "Something came up: #{body}"

withUserId = (msg, callback) ->
  user = sprintlyUser(msg)
  if user.user_id
    callback(user.user_id)
  else
    sprintly(msg).product()
      .scope('people.json')
      .get() (err, res, body) ->
        if res.statusCode == 200
          payload = JSON.parse(body)
          user_email = user.auth.split(':')[0]
          for {id, email} in payload when email == user_email
            user.user_id = id
            callback(id)
            break
        else
          msg.send "Something came up: #{body}"
