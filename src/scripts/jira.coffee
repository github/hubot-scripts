# Messing with the JIRA REST API
#
# <Project Key>-<Issue ID>      - Displays information about the ticket (if it exists)
# show watchers for <Issue Key> - Shows watchers for the given issue
# search for <JQL>              - Search JIRA with JQL
# save filter <JQL> as <name>   - Save JQL as filter in the brain
# use filter                    - Use a filter from the brain
# show filter(s)                - Show all filters
# show filter <name>            - Show a specific filter

class IssueFilters
  constructor: (@robot) ->
    @cache = []

    @robot.brain.on 'loaded', =>
      @cache = @robot.brain.data.jqls

  add: (filter) ->
    @cache.push filter
    @robot.brain.data.jqls = @cache

  delete: (name) ->
    result = []
    @cache.forEach (filter) ->
      if filter.name isnt name
        result.push filter

    @cache = result
    @robot.brain.data.jqls = @cache

  get: (name) ->
    result = null

    @cache.forEach (filter) ->
      if filter.name is name
        result = filter

    result
  all: ->
    return @cache

class IssueFilter
  constructor: (@name, @jql) ->
    return {name: @name, jql: @jql}

module.exports = (robot) ->
  filters = new IssueFilters robot

  useV2 = process.env.HUBOT_JIRA_USE_V2 || false

  get = (msg, where, cb) ->
    console.log(process.env.HUBOT_JIRA_URL + "/rest/api/latest/" + where)
    authdata = new Buffer(process.env.HUBOT_JIRA_USER+':'+process.env.HUBOT_JIRA_PASSWORD).toString('base64')

    msg.http(process.env.HUBOT_JIRA_URL + "/rest/api/latest/" + where).
      header('Authorization', 'Basic ' + authdata).
      get() (err, res, body) ->
        cb JSON.parse(body)

  watchers = (msg, issue, cb) ->
    get msg, "issue/#{issue}/watchers", (watchers) ->
      if watchers.errors?
        return

      cb watchers.watchers.map((watcher) -> return watcher.displayName).join(", ")

  info = (msg, issue, cb) ->
    get msg, "issue/#{issue}", (issues) ->
      if issues.errors?
        return

      if useV2
        issue =
          key: issues.key
          summary: issues.fields.summary
          assignee: ->
            if issues.fields.assignee != null
              issues.fields.assignee.displayName
            else
              "no assignee"
          status: issues.fields.status.name
          fixVersion: ->
            if issues.fields.fixVersions? and issues.fields.fixVersions.length > 0
              issues.fields.fixVersions.map((fixVersion) -> return fixVersion.name).join(", ")
            else
              "no fix version"
          url: process.env.HUBOT_JIRA_URL + '/browse/' + issues.key
      else
        issue =
          key: issues.key
          summary: issues.fields.summary.value
          assignee: ->
            if issues.fields.assignee.value != undefined
              issues.fields.assignee.value.displayName
            else
              "no assignee"
          status: issues.fields.status.value.name
          fixVersion: ->
            if issues.fields.fixVersions? and issues.fields.fixVersions.value != undefined
              issues.fields.fixVersions.value.map((fixVersion) -> return fixVersion.name).join(", ")
            else
              "no fix version"
          url: process.env.HUBOT_JIRA_URL + '/browse/' + issues.key

      cb "[#{issue.key}] #{issue.summary}. #{issue.assignee()} / #{issue.status}, #{issue.fixVersion()} #{issue.url}"
      
  search = (msg, jql, cb) ->
    get msg, "search/?jql=#{escape(jql)}", (result) ->
      if result.errors?
        return
      
      resultText = "I found #{result.total} issues for your search. #{process.env.HUBOT_JIRA_URL}/secure/IssueNavigator.jspa?reset=true&jqlQuery=#{escape(jql)}"
      max = if process.env.HUBOT_JIRA_LISTMAX? then process.env.HUBOT_JIRA_LISTMAX else 10
      if result.issues.length <= max
        cb resultText
        result.issues.forEach (issue) ->
          info msg, issue.key, (info) ->
            cb info
      else
        cb resultText + " (too many to list)"
  
  robot.respond /(show )?watchers (for )?(\w+-[0-9]+)/i, (msg) ->
    if msg.message.user.id is robot.name
      return

    watchers msg, msg.match[3], (text) ->
      msg.reply text
  
  robot.respond /search (for )?(.*)/i, (msg) ->
    if msg.message.user.id is robot.name
      return
      
    search msg, msg.match[2], (text) ->
      msg.reply text
  
  robot.hear /(\w+-[0-9]+)/ig, (msg) ->
    if msg.message.user.id is robot.name
      return
    
    for matched in msg.match
      info msg, matched, (text) ->
        msg.send text

  robot.respond /save filter (.*) as (.*)/i, (msg) ->
    filter = filters.get msg.match[2]

    if filter
      filters.delete filter.name
      msg.reply "Updated filter #{filter.name} for you"

    filter = new IssueFilter msg.match[2], msg.match[1]
    filters.add filter

  robot.respond /delete filter (.*)/i, (msg) ->
    filters.delete msg.match[1]

  robot.respond /(use )?filter (.*)/i, (msg) ->
    name    = msg.match[2]
    filter  = filters.get name

    search msg, filter.jql, (text) ->
      msg.reply text

  robot.respond /(show )?filter(s)? ?(.*)?/i, (msg) ->
    if filters.all().length == 0
      msg.reply "Sorry, I don't remember any filters."
      return

    if msg.match[3] == undefined
      msg.reply "I remember #{filters.all().length} filters"
      filters.all().forEach (filter) ->
        msg.reply "#{filter.name}: #{filter.jql}"
    else
      filter = filters.get msg.match[3]
      msg.reply "#{filter.name}: #{filter.jql}"
