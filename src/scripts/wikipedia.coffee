# wiki me <query> - Searches for <query> on Wikipedia.

# Original Author: Brad Fults (h3h.net) - 2011-11-09
# 
# Copyright (c) 2011 Gowalla Incorporated
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

_          = require("underscore")
_s         = require("underscore.string")
Select     = require("soupselect").select
HTMLParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /(wiki)( me)? (.*)/i, (msg) ->
    wikiMe msg, msg.match[3], (text, url) ->
      msg.send text
      msg.send url if url

wikiMe = (msg, query, cb) ->
  articleURL = makeArticleURL(makeTitleFromQuery(query))

  msg.http(articleURL)
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
  "http://en.wikipedia.org/wiki/#{encodeURIComponent(title)}"

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
