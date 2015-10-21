# Description:
#   Messing with the JIRA REST API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_URL
#   HUBOT_JIRA_USER
#   HUBOT_JIRA_PASSWORD
#   Optional environment variables:
#   HUBOT_JIRA_USE_V2 (defaults to "true", set to "false" for JIRA earlier than 5.0)
#   HUBOT_JIRA_MAXLIST
#   HUBOT_JIRA_ISSUEDELAY
#   HUBOT_JIRA_IGNOREUSERS
#
# Commands:
#   <Project Key>-<Issue ID> - Displays information about the JIRA ticket (if it exists)
#   hubot show watchers for <Issue Key> - Shows watchers for the given JIRA issue
#   hubot search for <JQL> - Search JIRA with JQL
#   hubot save filter <JQL> as <name> - Save JIRA JQL query as filter in the brain
#   hubot use filter <name> - Use a JIRA filter from the brain
#   hubot show filter(s) - Show all JIRA filters
#   hubot show filter <name> - Show a specific JIRA filter
#
# Author:
#   codec

class IssueFilters
  constructor: (@robot) ->
    @cache = []

    @robot.brain.on 'loaded', =>
      jqls_from_brain = @robot.brain.data.jqls
      # only overwrite the cache from redis if data exists in redis
      if jqls_from_brain
        @cache = jqls_from_brain

  add: (filter) ->
    @cache.push filter
    @robot.brain.data.jqls = @cache

  delete: (name) ->
    result = []
    @cache.forEach (filter) ->
      if filter.name.toLowerCase() isnt name.toLowerCase()
        result.push filter

    @cache = result
    @robot.brain.data.jqls = @cache

  get: (name) ->
    result = null

    @cache.forEach (filter) ->
      if filter.name.toLowerCase() is name.toLowerCase()
        result = filter

    result
  all: ->
    return @cache

class IssueFilter
  constructor: (@name, @jql) ->
    return {name: @name, jql: @jql}


# keeps track of recently displayed issues, to prevent spamming
class RecentIssues
  constructor: (@maxage) ->
    @issues = []

  cleanup: ->
    for issue,time of @issues
      age = Math.round(((new Date()).getTime() - time) / 1000)
      if age > @maxage
        #console.log 'removing old issue', issue
        delete @issues[issue]
    0

  contains: (issue) ->
    @cleanup()
    @issues[issue]?

  add: (issue,time) ->
    time = time || (new Date()).getTime()
    @issues[issue] = time


module.exports = (robot) ->
  filters = new IssueFilters robot

  useV2 = process.env.HUBOT_JIRA_USE_V2 != "false"
  # max number of issues to list during a search
  maxlist = process.env.HUBOT_JIRA_MAXLIST || 10
  # how long (seconds) to wait between repeating the same JIRA issue link
  issuedelay = process.env.HUBOT_JIRA_ISSUEDELAY || 30
  # array of users that are ignored
  ignoredusers = (process.env.HUBOT_JIRA_IGNOREUSERS.split(',') if process.env.HUBOT_JIRA_IGNOREUSERS?) || []

  recentissues = new RecentIssues issuedelay

  get = (msg, where, cb) ->
    console.log(process.env.HUBOT_JIRA_URL + "/rest/api/latest/" + where)

    httprequest = msg.http(process.env.HUBOT_JIRA_URL + "/rest/api/latest/" + where)
    if (process.env.HUBOT_JIRA_USER)
      authdata = new Buffer(process.env.HUBOT_JIRA_USER+':'+process.env.HUBOT_JIRA_PASSWORD).toString('base64')
      httprequest = httprequest.header('Authorization', 'Basic ' + authdata)
      
    httprequest.get() (err, res, body) ->
      if err
        res.send "GET failed :( #{err}"
        return

      if res.statusCode is 200
        cb JSON.parse(body)
      else
        console.log("res.statusCode = " + res.statusCode)
        console.log("body = " + body)

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
      if result.issues.length <= maxlist
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
      msg.send text

  robot.respond /search (for )?(.*)/i, (msg) ->
    if msg.message.user.id is robot.name
      return

    search msg, msg.match[2], (text) ->
      msg.reply text

  robot.respond /([^\w\-]|^)(\w+-[0-9]+)(?=[^\w]|$)/ig, (msg) ->
    if msg.message.user.id is robot.name
      return

    if (ignoredusers.some (user) -> user == msg.message.user.name)
      console.log 'ignoring user due to blacklist:', msg.message.user.name
      return

    for matched in msg.match
      ticket = (matched.match /(\w+-[0-9]+)/)[0]
      if !recentissues.contains msg.message.user.room+ticket
        info msg, ticket, (text) ->
          msg.send text
        recentissues.add msg.message.user.room+ticket

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

    if not filter
      msg.reply "Sorry, could not find filter #{name}"
      return

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
