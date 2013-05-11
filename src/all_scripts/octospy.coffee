# Description:
#   Octospy GitHub events, watch what's happening with your projects
#   Powered by http://developer.github.com/v3/repos/hooks/
#
# Dependencies:
#   "underscore": "1.3.3"
#   "handlebars": "1.0.5beta"
#
# Configuration:
#   HUBOT_URL
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_PASSWORD
#   or
#   HUBOT_GITHUB_TOKEN
#
# Commands:
#   hubot octospy <repo> [event_type] - Start watching events for the repo, default push
#   hubot octospy stop <repo> [event_type] - Stop watching events for the repo
#   hubot octospying - Show what you're spying on
#   hubot octospy events - List the events you can watch
#
# Author:
#   rcs

_ = require 'underscore'
QS = require 'querystring'
Handlebars = require 'handlebars'

Handlebars.registerHelper 'trim', (str, length) ->
  str.substring 0, length

Handlebars.registerHelper 'overflow', (str, length) ->
  if str.length > length
    str.substring(0,length-3) + '...'
  else
    str

# Internal: Given a template name and a context, return the compiled template.
# Returns JSONed context if no template is found.
#
# event   - The event type we're rendering
# context - The object to give the template
#
# If the template in the views hash is a function, pass it the context to get the specific template
renderTemplate = (event,context) ->
  if views[event]
    if _.isFunction(views[event])
      message = views[event](context)
    else
      template = Handlebars.compile(views[event])
      message = template(context)
  else
    # We couldn't find a template, so let's push this out. People on github like JSON, right?
    message = {}
    message[event] = req.body
    message = JSON.stringify message

  return message

# Private: Helper method for pubsub modification.
#
# msg    - The hubot msg object, used for its http client
# action - The action to take, 'subscribe' or 'unsubscribe'
# target - The hash containing the subscription we want to work on
#          github_url - The base github URL
#          repo       - The repository
#          event      - The event type
# cb     - Function to pass as a callback to the HTTP call
#
# Example:
#
# pubsub_modify(msg, 'subscribe', { github_url: 'github.com', repo: 'github/hubot', event: 'push' }, (err,resp,body) -> msg.send "aaaaaallllright.")
#
pubsub_modify = (msg, action, target, cb) ->
  {github_url, repo, event} = target

  data = QS.stringify {
    "hub.mode": action,
    "hub.topic": "https://#{github_url}/#{repo}/events/#{event}.json"
    "hub.callback": "#{process.env.HUBOT_URL}/hubot/octospy/#{github_url}/#{event}"
  }

  # Check authentication, return error if it isn't specified
  if process.env.HUBOT_GITHUB_TOKEN
    auth = "token #{process.env.HUBOT_GITHUB_TOKEN}"
  else if (process.env.HUBOT_GITHUB_USER and process.env.HUBOT_GITHUB_PASSWORD)
    auth = 'Basic ' + new Buffer("#{process.env.HUBOT_GITHUB_USER}:#{process.env.HUBOT_GITHUB_PASSWORD}").toString('base64')
  else
    return cb({},{statusCode: 401}, {message: "Octospy doesn't have credentials"})

  msg.http("https://api.#{github_url}")
    .path('/hub')
    .header('Authorization', auth)
    .post(data) cb


# These are views for each of the event types.
# Note: Handlebars likes to HTML escape things. It's kinda lame as a default. {{{ }}} to avoid it.
views =
  push: (context) ->
    if context.created
      template = """
        {{pusher.name}} created a new branch "{{branch}}" on {{repo_name}} {{compare}}
      """
    else
      if context.commits.length > 3
        context.extra_commits = context.commits.length - 3

      context.short_commits = context.commits.slice(0,3)
      template = """
        {{pusher.name}} pushed to {{branch}} at {{repo_name}} {{compare}}
        {{#each short_commits}}  {{author.username}}: {{trim id 7}} {{{overflow message 80}}}
        {{/each}}{{#if extra_commits }}  ... +{{extra_commits}} more{{/if}}
      """

    template = Handlebars.compile(template)
    message = template(context)
  issues:
    """
      {{sender.login}} {{action}} issue {{issue.number}} on {{repo_name}} "{{{overflow issue.title 25}}}" {{issue.html_url}}
    """
  issue_comment:
    """
      {{sender.login}} commented on issue {{issue.number}} on {{repo_name}} "{{{overflow issue.title 25}}}" {{issue.html_url}}
      > {{{overflow comment.body 120}}}
    """
  commit_comment:
    """
    {{sender.login}} commented on commit {{comment.commit_id}} on {{repo_name}} {{comment.html_url}}
    > {{{overflow comment.body 120}}}
    """
  pull_request: (context) ->
    template = switch context.action
      when 'opened'
        """
          {{sender.login}} {{action}} pull request {{number}} on {{repo_name}}: "{{{overflow pull_request.title 25}}}" {{pull_request.html_url}}
          {{pull_request.commits}} commits with {{pull_request.additions}} additions and {{pull_request.deletions}} deletions
        """
      when 'closed'
        switch context.pull_request.merged
          when true
            """
              {{sender.login}} merged pull request {{number}} on {{repo_name}}: "{{{overflow pull_request.title 25}}}" {{pull_request.html_url}}
            """
          else
            """
              {{sender.login}} closed pull request {{number}} on {{repo_name}} without merging: "{{{overflow pull_request.title 25}}}" {{pull_request.html_url}}
            """
      when 'synchronize'
        """
          {{sender.login}} updated pull request {{number}} on {{repo_name}}: "{{{overflow pull_request.title 25}}}" {{pull_request.html_url}}
        """
    template = Handlebars.compile(template)
    message = template(context)

  gollum:
    """
      {{#each pages}}
        {{../sender.login}} {{action}} wiki page on {{repo_name}}: "{{{overflow title 25}}}" {{html_url}}
      {{/each}}
    """
  watch:
    """
      {{sender.login}} started watching {{repo_name}} http://{{github_url}}/{{sender.login}}
    """
  download:
    """
      {{sender.login}} added a download to {{repo_name}}: "{{{overflow download.name 25}}}" {{download.html_url}}
    """
  fork:
    """
      {{sender.login}} forked {{repo_name}} {{forkee.html_url}}
    """
  fork_apply:
    """
      {{sender.login}} merged from the fork queue to {{head}} on {{repo_name}}
    """
  member:
    """
      {{sender.login}} added {{member.login}} as a collaborator to {{repo_name}}
    """
  public:
    """
      {{sender.login}} turned {{repo_name}} public
    """



module.exports = (robot) ->

  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    robot.brain.data.octospy ||= {}

  # Public: Announce the kinds of things octospy knows about
  robot.respond /octospy events/i, (msg) ->
    msg.reply "I know about " + ( event for event of views ).join(', ')

  # Public: Dump the watching hash
  robot.respond /octospying/i, (msg) ->
    watching = []

    # Troll octospy's data for any possible listeners, then see if they're us
    for github_url, github of robot.brain.data.octospy
      for repo_name, repo of github
        for event, listeners of repo
          if _.include(listeners, msg.message.user.id)
            watching.push
              github_url: github_url
              repo_name: repo_name
              event: event

    if watching.length > 0
      msg.reply (for sub in watching
        "#{sub.repo_name} #{sub.event} events" + if sub.github_url != 'github.com'
            " on #{sub.github_url}"
          else
            ""
      )
    else
      msg.reply "I don't think you're octospying anything"


  # Public: Unsubscribe from an event type for a repository
  #
  # repo       - The repository name (ex. 'github/hubot'
  # event      - The event type to stop watching (default: 'push')
  # github_url - The base github URL (default: 'github.com'
  robot.respond /octospy stop ([^ ]+\/[^ ]+) ?([^ ]*)? ?([^ ]*)?/i, (msg) ->
    repo = msg.match[1]
    event = msg.match[2] || 'push'
    github_url = msg.match[3] || 'github.com'

    # Convenience accessor
    listeners = robot.brain.data.octospy[github_url]?[repo]?[event]

    if ! listeners
      return msg.send "Can't find any octospies for #{repo} #{event} events"

    # Find the user in possible listeners
    for listener, i in listeners when listener == msg.message.user.id
      removed = listeners.splice(i,1)

    # Didn't find the user
    if ! removed
      return msg.reply "I don't think you're octospying #{repo} #{event} events"
    else
      msg.reply "Unoctospied #{repo} #{event} events on #{github_url}"



    # We're done if nobody's left
    return unless listeners.length == 0

    # Otherwise we unsub
    pubsub_modify msg, 'unsubscribe', { github_url: github_url, repo: repo, event: event },
      (err,res,body) ->
        switch res.statusCode
          when 204
            data = robot.brain.data.octospy
            repos = data[github_url]
            events = repos[repo]

            # Clean up after ourselves
            delete events[event]
            delete repos[repo] if (a for a of events).length == 0
            delete data[github_url] if (a for a of repos).length == 0

            # Here to hook the redis magic
            # robot.brain.data.octospy = data

            robot.logger.info "The last user unsubscribed. Removed my subscription to #{repo} #{event} events"
          else
            robot.logger.warning "Failed to unsubscribe to #{repo} #{event} events on #{github_url}: #{body} (Status Code: #{res.statusCode})"

  # Public: Subsribe to an event type for a repository
  #
  # repo       - The repository name (ex. 'github/hubot'
  # event      - The event type to stop watching (default: 'push')
  # github_url - The base github URL (default: 'github.com'
  robot.respond /octospy ([^ ]+\/[^ ]+) ?([^ ]*)? ?([^ ]*)?/i, (msg) ->
    repo = msg.match[1]
    event = msg.match[2] || 'push'
    github_url = msg.match[3] || 'github.com'

    # Don't go any further if we don't know about the event type
    if ! _.include(( known for known of views ), event)
      return msg.reply "Sorry, I don't know about #{event} events"

    # Convenience accessor
    listeners = robot.brain.data.octospy[github_url]?[repo]?[event]

    # Internal: Add a listener
    #
    # Closes around msg, repo, event, github_url
    addListener = ->
      # Vivify!
      repos = robot.brain.data.octospy[github_url] ||= {}
      events = repos[repo] ||= {}
      listeners = events[event] ||= []

      # See whether we're already listening
      if (listener for listener in listeners when listener == msg.message.user.id).length == 0
        listeners.push msg.message.user.id
        msg.reply "Octospying #{repo} #{event} events on #{github_url}"
      else
        msg.reply "You're already octospying that."

    # Check to see if we have any subscriptions to this event type for the
    # repo, and if not, register the subscription
    if ! listeners
      pubsub_modify msg, 'subscribe', { github_url: github_url, repo: repo, event: event },
        (err,res,body) ->
          switch res.statusCode
            when 204
              addListener()
            when 401
              msg.reply """
                Failed to auth: #{JSON.stringify body}
                Specify credentials in the environment. (HUBOT_GITHUB_USERNAME,HUBOT_GITHUB_PASSWORD) or HUBOT_GITHUB_TOKEN"
                To create a token: curl -u 'user:pass' https://api.github.com/authorizations -d '{"scopes":["repo"],"note":"Hubot Octospy"}'
              """
            when 422
              msg.reply "Either #{repo} doesn't exist, or my credentials don't make me a collaborator on it. Couldn't subscribe."
              robot.logger.info "#{JSON.stringify body}"
            else
              msg.reply "I failed to subscribe to #{repo} #{event} events on #{github_url}: #{body} (Status Code: #{res.statusCode})"
              robot.logger.warning "#{JSON.stringify body}"
    else
      addListener()

  # Public: Repond to POSTs from github
  #
  # :github - The github base url we registered, so we know the source of this POST
  # :event  - The event type that was registered
  robot.router.post '/hubot/octospy/:github/:event', (req, res) ->
    req.body = req.body || {}

    return res.end "ok" unless req.body.repository # Not something we care about. Who does this?

    # Convenience accessors
    event = req.params.event
    repo_name =  (req.body.repository.owner.login || req.body.repository.owner.name) + "/" + req.body.repository.name
    github_url = req.params.github

    # Extend the context for our templates
    context = _.extend req.body,
      repo: req.body.repository
      repo_name: repo_name
      github_url: github_url
      branch: if req.body.ref
          req.body.ref.replace(/^refs\/heads\//,'')
        else
          undefined

    message = '[octospy] ' +  renderTemplate(event,context)

    # Tell the people who care
    listeners = (robot.brain.userForId(id) for id in (robot.brain.data.octospy[github_url]?[repo_name][event] || []))

    # group rooms together, so we don't spam with multiple people with subs
    for room, users of _.groupBy(listeners, 'room') when room
      robot.send users[0], message

    # For users without rooms, send individually
    for room, users of _.groupBy(listeners, 'room') when ! room
      robot.send(user, message) for user in users

    res.writeHead(204)
    res.end()
