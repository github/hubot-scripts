# Description:
#   Display issue/page information from drupal.org
#
# Dependencies:
#   "jsdom" : ">0.2.1"
#   "request" : ""
#
# Configuration:
#   NONE
#
# Commands:
#   Drupal.org url - Show details about a drupal.org page or issue
#
# Notes:
#   HUBOT_DRUPALORG_LINKDELAY: number of seconds to not respond to a link again after it's been
#                             mentioned once. This helps to cut down on noise from the bot.
#                             Defaults to 30.
#
# Author:
#   guyoron


request = require 'request'
jsdom = require 'jsdom'
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'

# keeps track of recently displayed pages, to prevent spamming
class RecentIssues
  constructor: (@maxage) ->
    @issues = []

  cleanup: ->
    for issue,time of @issues
      age = Math.round(((new Date()).getTime() - time) / 1000)
      if age > @maxage
        delete @issues[issue]
    return

  contains: (issue) ->
    @cleanup()
    @issues[issue]?

  add: (issue,time) ->
    time = time || (new Date()).getTime()
    @issues[issue] = time

module.exports = (robot) ->
  # how long (seconds) to wait between repeating the same link
  
  linkDelay = process.env.HUBOT_DRUPALORG_LINKDELAY || 30

  recentLinks = new RecentIssues linkDelay
      
  # scrape (already retrieved) HTML
  # selectors: an array of jquery selectors
  # callback: function that takes scrape results
  scrape = (body, selectors, callback) ->
    jsdom.env body, [jquery], (errors, window) ->
      # use jquery to run selector and return the elements
      callback (window.$(selector).text().trim() for selector in selectors)

  # fetch a drupal.org page using http scraping
  fetchPage = (msg) ->
    url = msg.match[0]
    return if recentLinks.contains url
    recentLinks.add url
    request {url: url, headers: {'User-Agent': 'hubot'}}, (err, res, body) ->
      if err
        console.log "Errors getting url: #{url}"
        return   
      # check if this is an issue or non-issue page 
      scrape body, ['#project-issue-summary-table tbody tr:first-child td:last-child', 'dl.about-section dd:nth-child(2)'], (result) ->
        if result[0] != ''
          outputIssue msg, url, body
        else if result[1] != ''
          outputPage msg, url, body
        else
          console.log "Errors scraping url: #{url}"

  # outputs info about a d.o issue, given a scrape response
  outputIssue = (msg, url, body) ->
    scrape body,
      [
        '#page-subtitle',                                                     # title
        '#project-issue-summary-table tbody tr:first-child td:last-child',    # project name
        '#project-issue-summary-table tbody tr:last-child td:last-child',     # status
        'div.comment:last-child h3.comment-title a',                          # last comment number
        'div.project-issue-follow-count'                                      # follower count
      ], 
      (results) ->
        commentNumber = results[3].substring(1)
        if commentNumber != '' 
          comments = commentNumber + " comments"
        else 
          comments = "0 comments"
        msg.send "#{url} => #{results[0]} [#{results[1]}, #{results[2]}, #{comments}, #{results[4]}]"

  # outputs info about a d.o non-issue page, given a scrape response
  outputPage = (msg, url, body) ->
    scrape body,
      [
        '#page-subtitle',                    # title
        'dl.about-section dd:nth-child(2)'   # drupal versions
        'dl.about-section dd:last-child'     # audience
      ],
      (results) ->
        msg.send "#{url} => #{results[0]} [#{results[1]}, #{results[2]}]"

  # listen for page links
  robot.hear /https?:\/\/(www.)?drupal.org\/node\/(\d+)/, fetchPage
