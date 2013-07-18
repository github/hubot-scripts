# Description:
#   None
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#   "underscore": "1.3.3"
#   "underscore.string": "2.3.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot wiki me <query> - Searches for <query> on Wikipedia.
#
# Author:
#   h3h

_          = require("underscore")
_s         = require("underscore.string")
Select     = require("soupselect").select
HTMLParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /(wiki)( me)? (.*)/i, (msg) ->
    wikiMe robot, msg.match[3], (text, url) ->
      msg.send text
      msg.send url if url

wikiMe = (robot, query, cb) ->
  articleURL = makeArticleURL(makeTitleFromQuery(query))

  robot.http(articleURL)
    .header('User-Agent', 'Hubot Wikipedia Script')
    .get() (err, res, body) ->
      return cb "Sorry, the tubes are broken." if err

      if res.statusCode is 301
        return cb res.headers.location

      if /does not have an article/.test body
        return cb "Wikipedia has no idea what you're talking about."

      paragraphs = parseHTML(body, "p")

      bodyText = findBestParagraph(paragraphs) or "Have a look for yourself:"
      cb bodyText, articleURL

# Utility Methods

childrenOfType = (root, nodeType) ->
  return [root] if root?.type is nodeType

  if root?.children?.length > 0
    return (childrenOfType(child, nodeType) for child in root.children)

  []

findBestParagraph = (paragraphs) ->
  return null if paragraphs.length is 0

  childs = _.flatten childrenOfType(paragraphs[0], 'text')
  text = (textNode.data for textNode in childs).join ''

  # remove parentheticals (even nested ones)
  text = text.replace(/\s*\([^()]*?\)/g, '').replace(/\s*\([^()]*?\)/g, '')
  text = text.replace(/\s{2,}/g, ' ')               # squash whitespace
  text = text.replace(/\[[\d\s]+\]/g, '')           # remove citations
  text = _s.unescapeHTML(text)                      # get rid of nasties

  # if non-letters are the majority in the paragraph, skip it
  if text.replace(/[^a-zA-Z]/g, '').length < 35
    findBestParagraph(paragraphs.slice(1))
  else
    text

makeArticleURL = (title) ->
  "https://en.wikipedia.org/wiki/#{encodeURIComponent(title)}"

makeTitleFromQuery = (query) ->
  strCapitalize(_s.trim(query).replace(/[ ]/g, '_'))

parseHTML = (html, selector) ->
  handler = new HTMLParser.DefaultHandler((() ->),
    ignoreWhitespace: true
  )
  parser  = new HTMLParser.Parser handler
  parser.parseComplete html

  Select handler.dom, selector

strCapitalize = (str) ->
  return str.charAt(0).toUpperCase() + str.substring(1);
