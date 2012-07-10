# Description:
#   Trac interaction script
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_TRAC_URL: Base URL to Trac instance, without trailing slash eg: https://myserver.com/trac
#   HUBOT_TRAC_USER: Trac username (uses HTTP basic authentication)
#   HUBOT_TRAC_PASSWORD: Trac password
#
# Optional Configuration:
#   HUBOT_TRAC_JSONRPC: "true" to use the Trac http://trac-hacks.org/wiki/XmlRpcPlugin.
#                       Requires jsonrpc to be enabled in the plugin. Default to "true".
#   HUBOT_TRAC_SCRAPE: "true" to use HTTP scraping to pull information from Trac. 
#                      Defaults to "true".
#   HUBOT_TRAC_LINKDELAY: number of seconds to not show a link for again after it's been
#                         mentioned once. This helps to cut down on noise from the bot.
#                         Defaults to 30.
#   HUBOT_TRAC_IGNOREUSERS: Comma-seperated list of users to ignore "hearing" issues from.
#                           This works well with other bots or API calls that post to the room.
#                           Example: "Subversion,TeamCity,John Doe"
# Commands:
#   #123 - Show details about a Trac ticket
#   Full ticket URL - Show details about a Trac ticket
#   r123 - Show details about a commit
#   [123] - Show details about a commit
#
# Notes: 
#   Tickets pull from jsonrpc (if enabled), then scraping (if enabled), and otherwise just put a link
#   Revisions pull from scraping (if enabled), and otherwise just post a link. (There are no xmlrpc methods
#   for changeset data).
#
# Author:
#   gregmac


jsdom = require 'jsdom'
#fs = require 'fs'  #todo: load jquery from filesystem
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'

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
    return

  contains: (issue) ->
    @cleanup()
    @issues[issue]?

  add: (issue,time) ->
    time = time || (new Date()).getTime()
    @issues[issue] = time

module.exports = (robot) ->
  # if trac json-rpc is available to use for retreiving tickets (faster)
  useJsonrpc = process.env.HUBOT_TRAC_JSONRPC || false

  # if screen scraping can be used for tickets/changesets. If both jsonrpc and scrape are off, only a link gets posted
  useScrape = process.env.HUBOT_TRAC_SCRAPE || true

  # how long (seconds) to wait between repeating the same link
  linkdelay = process.env.HUBOT_TRAC_LINKDELAY || 30

  # array of users that are ignored
  ignoredusers = (process.env.HUBOT_TRAC_IGNOREUSERS.split(',') if process.env.HUBOT_TRAC_IGNOREUSERS?) || []

  recentlinks = new RecentIssues linkdelay
      
  # scrape a URL
  # selectors: an array of jquery selectors
  # callback: function that takes (error,response)
  scrapeHttp = (msg, url, user, pass, selectors, callback) ->
    authdata = new Buffer(user+':'+pass).toString('base64')

    msg.http(url).
      header('Authorization', 'Basic ' + authdata).
      get() (err, res, body) ->
        # http errors
        if err
          callback err, body
          return
        jsdom.env body, [jquery], (errors, window) ->
          # use jquery to run selector and return the elements
          results = (window.$(selector).text().trim() for selector in selectors)
          callback null, results

  # call a json-rpc method
  # callback is passed (error,response) 
  # borrowed heavily from https://github.com/andyfowler/node-jsonrpc-client/
  jsonRpc = (msg, url, user, pass, method, params, callback) ->
    authdata = new Buffer(user+':'+pass).toString('base64')

    jsonrpcParams =
      jsonrpc: '2.0'
      id:      (new Date).getTime()
      method:  method
      params:  params

    console.log url, JSON.stringify jsonrpcParams
    msg.http(url).
      header('Authorization', 'Basic ' + authdata).
      header('Content-Type', 'application/json').
      post(JSON.stringify jsonrpcParams) (err, res, body) ->
        # http errors
        if err
          callback err, body
          return

        # response json parse errors
        try
          decodedResponse = JSON.parse body
        catch decodeError
          callback 'Could not decode JSON response', body
          return
        
        #json-rpc errors
        if decodedResponse.error
          errorMessage = " #{decodedResponse.error.message}"
          callback errorMessage, decodedResponse.error.data
          return

        callback null, decodedResponse.result

 
  # fetch a ticket using json-rpc
  ticketRpc = (msg, ticket) ->
    jsonRpc msg, process.env.HUBOT_TRAC_URL+'/login/jsonrpc', process.env.HUBOT_TRAC_USER, process.env.HUBOT_TRAC_PASSWORD, 
      'ticket.get', [ticket],
      (err,response) ->
        if err
          console.log 'Error retrieving trac ticket', ticket, err
          return

        ticketid = response[0]
        issue = response[3]

        if !ticketid
          console.log 'Error understanding trac response', ticket, response
          return

        url = process.env.HUBOT_TRAC_URL+"/ticket/"+ticketid
        msg.send "Trac \##{ticketid}: #{issue.summary}. #{issue.owner} / #{issue.status}, #{issue.milestone} #{url}"

  # fetch a ticket using http scraping
  ticketScrape = (msg, ticket) ->
    scrapeHttp  msg, process.env.HUBOT_TRAC_URL+'/ticket/'+ticket, process.env.HUBOT_TRAC_USER, process.env.HUBOT_TRAC_PASSWORD,
      ['#ticket h2.summary', 'td[headers=h_owner]', '#trac-ticket-title .status', 'td[headers=h_milestone]']
      (err, response) ->
        console.log 'scrape response', response
        url = process.env.HUBOT_TRAC_URL+"/ticket/"+ticket
        msg.send "Trac \##{ticket}: #{response[0]}. #{response[1]} / #{response[2]}, #{response[3]} #{url}"


  # fetch a changeset using http scraping
  changesetScrape = (msg, revision) ->
    scrapeHttp  msg, process.env.HUBOT_TRAC_URL+'/changeset/'+revision, process.env.HUBOT_TRAC_USER, process.env.HUBOT_TRAC_PASSWORD,
      ['#content.changeset dd.message', '#content.changeset dd.author', '#content.changeset dd.time']
      (err, response) ->
        console.log 'scrape response', response
        url = process.env.HUBOT_TRAC_URL+"/changeset/"+revision
        author = response[1]
        time = response[2].replace(/[\n ]{2,}/,' ')
        message = response[0]
        msg.send "Trac r#{revision}: #{author} #{time} #{url}"
        msg.send line for line in message.split("\n")

  # fetch ticket information using scraping or jsonrpc
  fetchTicket = (msg) ->
    if (ignoredusers.some (user) -> user == msg.message.user.name)
      console.log 'ignoring user due to blacklist:', msg.message.user.name
      return

    for matched in msg.match
      ticket = (matched.match /\d+/)[0]
      linkid = msg.message.user.room+'#'+ticket
      if !recentlinks.contains linkid
        recentlinks.add linkid
        console.log 'trac ticket link', ticket

        if useJsonrpc
          ticketRpc msg, ticket
        else if useScrape
          ticketScrape msg, ticket
        else
          msg.send "Trac \##{ticket}: #{process.env.HUBOT_TRAC_URL}/ticket/#{ticket}"

  # listen for ticket numbers
  robot.hear /([^\w]|^)\#(\d+)(?=[^\w]|$)/ig, fetchTicket

  # listen for ticket links
  ticketUrl = new RegExp("#{process.env.HUBOT_TRAC_URL}/ticket/([0-9]+)", 'ig')
  robot.hear ticketUrl, fetchTicket

  # listen for changesets 
  handleChangeset = (msg) ->
    if (ignoredusers.some (user) -> user == msg.message.user.name)
      console.log 'ignoring user due to blacklist:', msg.message.user.name
      return

    for matched in msg.match
      revision = (matched.match /\d+/)[0]

      linkid = msg.message.user.room+'r'+revision
      if !recentlinks.contains linkid
        recentlinks.add linkid
        console.log 'trac changset link', revision

        # note, trac has no API methods for changesets, all we can do is scrape
        if useScrape
          changesetScrape msg, revision
        else
          msg.send "Trac r#{revision}: #{process.env.HUBOT_TRAC_URL}/changeset/#{revision}"

  # trigger on "r123"
  robot.hear /([^\w]|^)r(\d+)(?=[^\w]|$)/ig, handleChangeset
  # trigger on [123]
  robot.hear /([^\w]|^)\[(\d+)\](?=[^\w]|$)/ig, handleChangeset
  