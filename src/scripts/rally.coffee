# Description:
#   Rally information for artifacts
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_RALLY_USERNAME
#   HUBOT_RALLY_PASSWORD
#
# Commands:
#   hubot rally me <formattedID> - Lookup a task, story, defect, etc. from Rally
#
# Notes:
#   Since Rally supports rich text for description fields, it will come back as HTML
#   to pretty print this we can run it through lynx. Make sure you have lynx installed
#   and PATH accessible, otherwise we will degrade to just showing the html description.
#
# Author:
#   brianmichel

exec = require('child_process').exec

user = process.env.HUBOT_RALLY_USERNAME
pass = process.env.HUBOT_RALLY_PASSWORD
api_version = 'v2.0'

logger = null

typeInfoByPrefix =
  DE:
    name: 'defect'
    extraOutputFields: [
      'State'
      'ScheduleState'
      'Severity'
    ]
  DS:
    name: 'defectsuite'
    extraOutputFields: [
      'ScheduleState'
    ]
  F:
    name: 'feature'
    queryName: 'portfolioitem/feature'
    linkName: 'portfolioitem/feature'
    extraOutputFields: [
      'State._refObjectName'
      'Parent._refObjectName'
    ]
  I:
    name: 'initiative'
    queryName: 'portfolioitem/initiative'
    linkName: 'portfolioitem/initiative'
    extraOutputFields: [
      'State._refObjectName'
      'Parent._refObjectName'
    ]
  T:
    name: 'theme'
    queryName: 'portfolioitem/theme'
    linkName: 'portfolioitem/theme'
    extraOutputFields: [
      'State._refObjectName'
      'Parent._refObjectName'
    ]
  TA:
    name: 'task'
    extraOutputFields: [
      'State'
      'WorkProduct._refObjectName'
    ]
  TC:
    name: 'testcase'
    extraOutputFields: [
      'WorkProduct._refObjectName'
      'Type'
    ]
  US:
    name: 'story'
    queryName: 'hierarchicalrequirement'
    linkName: 'userstory'
    extraOutputFields: [
      'ScheduleState'
      'Parent._refObjectName'
      'Feature._refObjectName'
    ]


module.exports = (robot) ->
  logger = robot.logger
  robot.respond /(rally)( me)? ([a-z]+)(\d+)/i, (msg) ->
    if user && pass
      idPrefix = msg.match[3].toUpperCase()
      idNumber = msg.match[4]
      if typeInfoByPrefix.hasOwnProperty(idPrefix)
        queryRequest msg, typeInfoByPrefix[idPrefix], idNumber, (string) ->
          msg.send string
      else
        msg.send "Uhh, I don't know that formatted ID prefix"
    else
      msg.send 'You need to set HUBOT_RALLY_USERNAME & HUBOT_RALLY_PASSWORD before making requests!'

queryRequest = (msg, typeInfo, idNumber, cb) ->
  queryName = typeInfo.queryName || typeInfo.name
  queryString = "/#{queryName}.js?query=(FormattedID = #{idNumber})&fetch=true"
  rallyRequest msg, queryString, (json) ->
    if json && json.QueryResult.TotalResultCount > 0
      result = json.QueryResult.Results[0]
      linkName = typeInfo.linkName || typeInfo.name
      getLinkToItem msg, result, linkName
      description = 'No Description'
      prettifyDescription result.Description, (output) ->
        description = output || description
        returnArray = [
          "#{result.FormattedID} - #{result.Name}"
          labeledField(result, 'Owner._refObjectName')
          labeledField(result, 'Project._refObjectName')
        ]
        returnArray.push(labeledField(result, field)) for field in typeInfo.extraOutputFields
        returnArray.push("Description:")
        returnArray.push("#{description}")
        cb returnArray.join("\n")
    else
      cb "Aww snap, I couldn't find that #{typeInfo.name}!"

labeledField = (result, field) ->
  match = field.match(/^(\w+)\._refObjectName$/)
  if match
    "#{match[1]}: #{refObjectName(result, match[1])}"
  else
    "#{field}: #{result[field]}"

refObjectName = (result, field) ->
  if result[field] then result[field]._refObjectName else "No #{field}"

rallyRequest = (msg, query, cb) ->
  rally_url = 'https://rally1.rallydev.com/slm/webservice/' + api_version + query
#  logger.debug "rally_url = #{rally_url}"
  basicAuthRequest msg, rally_url, (json) ->
#    if json
#      logger.debug "json = #{JSON.stringify(json)}"
    cb json

basicAuthRequest = (msg, url, cb) ->
  auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
  msg.http(url)
    .headers(Authorization: auth, Accept: 'application/json')
    .get() (err, res, body) ->
      json_body = null
      switch res.statusCode
        when 200 then json_body = JSON.parse(body)
        else json_body = null
      cb json_body

getLinkToItem = (msg, object, type) ->
  project = if object && object.Project then object.Project else null
  if project
    objectId = object.ObjectID
    jsPos = project._ref.lastIndexOf '.js'
    lastSlashPos = project._ref.lastIndexOf '/'
    projectId = project._ref[(lastSlashPos+1)..(jsPos-1)]
    msg.send "https://rally1.rallydev.com/#/#{projectId}/detail/#{type}/#{objectId}"
  else
    #do nothing

prettifyDescription = (html_description, cb) ->
  child = exec "echo \"#{html_description}\" | lynx -dump -stdin", (error, stdout, stderr) ->
    return_text = html_description
    if !error
      return_text = stdout
    cb return_text

stripHtml = (html, cb) ->
  return_text = html.replace(/<style.+\/style>/g, '')
  return_text = return_text.replace(/<\/?.+?>/g, '').replace(/<br ?\/?>/g, "\n\n").replace(/&nbsp;/g, ' ').replace(/[ ]+/g, ' ').replace(/%22/g, '"').replace(/&amp;/g, '&')
  return_text = return_text.replace(/&gt;/g, '>').replace(/&lt;/g, '<')
  cb return_text
