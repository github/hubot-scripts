# Rally information for bugs, stories, and users
#
# rally me <defect id | task id | story id> - Lookup a task, story or defect from Rally
#
# ENV Variables Required:
# HUBOT_RALLY_USERNAME : username that hubot will use to login to Rally
# HUBOT_RALLY_PASSWORD : password that hubot will use to login to Rally
#
# Add to heroku:
# % heroku config:add HUBOT_RALLY_USERNAME="..."
# % heroku config:add HUBOT_RALLY_PASSWORD="..."
#
# PRETTY PRINTING SUPPORT
#  Since Rally supports rich text for description fields, it will come back as HTML
# to pretty print this we can run it through lynx. Make sure you have lynx installed
# and PATH accessible, otherwise we will degrade to just showing the html description.
#
exec = require('child_process').exec

user = process.env.HUBOT_RALLY_USERNAME
pass = process.env.HUBOT_RALLY_PASSWORD
api_version = 1.29

module.exports = (robot) ->
	robot.respond /(rally)( me)? (.*)/i, (msg) ->
		if user && pass
			switch msg.match[3].toUpperCase().substring(0,2)
				when "DE" then bugRequest msg, msg.match[3], (string) ->
					msg.send string
				when "TA" then taskRequest msg, msg.match[3], (string) ->
					msg.send string
				when "US" then storyRequest msg, msg.match[3], (string) ->
					msg.send string
				else msg.send "Uhh, that doesn't work"
		else
		  msg.send "You need to set HUBOT_RALLY_USERNAME & HUBOT_RALLY_PASSWORD before making requests!"

bugRequest = (msg, defectId, cb) ->
	query_string = '/defect.js?query=(FormattedId%20=%20'+defectId+')' + '&fetch=true'
	rallyRequest msg, query_string, (json) ->
		if json && json.QueryResult.TotalResultCount > 0
			getLinkToItem msg, json.QueryResult.Results[0], "defect"
			description = "No Description"
			if json.QueryResult.Results[0].Description
				prettifyDescription json.QueryResult.Results[0].Description, (output) ->
					description = output
					return_array = [
						"#{json.QueryResult.Results[0].FormattedID} - #{json.QueryResult.Results[0]._refObjectName}"
						"Owner - #{ if json.QueryResult.Results[0].Owner then json.QueryResult.Results[0].Owner._refObjectName else "No Owner" }"
						"Project - #{ if json.QueryResult.Results[0].Project then json.QueryResult.Results[0].Project._refObjectName else "No Project" }"
						"Severity - #{json.QueryResult.Results[0].Severity}"
						"State - #{json.QueryResult.Results[0].State}"
						"#{description}"
						]
					cb return_array.join("\n")
		else
			cb "Aww snap, I couldn't find that bug!"

taskRequest = (msg, taskId, cb) ->
	query_string = '/task.js?query=(FormattedId%20=%20'+taskId+')' + '&fetch=true'
	rallyRequest msg, query_string, (json) ->
		if json && json.QueryResult.TotalResultCount > 0
			getLinkToItem msg, json.QueryResult.Results[0], "task"
			return_array = [
				"#{json.QueryResult.Results[0].FormattedID} - #{json.QueryResult.Results[0].Name}"
				"Owner - #{ if json.QueryResult.Results[0].Owner then json.QueryResult.Results[0].Owner._refObjectName else "No Owner" }"
				"Project - #{ if json.QueryResult.Results[0].Project then json.QueryResult.Results[0].Project._refObjectName else "No Project" }"
				"State - #{json.QueryResult.Results[0].State}"
				"Feature - #{if json.QueryResult.Results[0].WorkProduct ? json.QueryResult.Results[0].WorkProduct._refObjectName  else "Not associated with any feature"}"
				]
			cb return_array.join("\n")
		else
			cb "Aww snap, I couldn't find that task!"

storyRequest = (msg, storyId, cb) ->
	query_string = '/hierarchicalrequirement.js?query=(FormattedId%20=%20'+storyId+')' + '&fetch=true'
	rallyRequest msg, query_string, (json) ->
		if json && json.QueryResult.TotalResultCount > 0
			getLinkToItem msg, json.QueryResult.Results[0], "userstory"
			description = "No Description"
			prettifyDescription json.QueryResult.Results[0].Description, (output) ->
				description = output || description
				return_array = [
					"#{json.QueryResult.Results[0].FormattedID} - #{json.QueryResult.Results[0].Name}"
					"Owner - #{ if json.QueryResult.Results[0].Owner then json.QueryResult.Results[0].Owner._refObjectName else "No Owner" }"
					"Project - #{ if json.QueryResult.Results[0].Project then json.QueryResult.Results[0].Project._refObjectName else "No Project" }"
					"ScheduleState - #{json.QueryResult.Results[0].ScheduleState}"
					"#{description}"
					]
				cb return_array.join("\n")
		else
			cb "Aww snap, I couldn't find that story!"

rallyRequest = (msg, query, cb) ->
	rally_url = 'https://rally1.rallydev.com/slm/webservice/' + api_version + query
	basicAuthRequest msg, rally_url, (json) ->
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
		jsPos = project._ref.lastIndexOf ".js"
		lastSlashPos = project._ref.lastIndexOf "/"
		projectId = project._ref[(lastSlashPos+1)..(jsPos-1)]
		msg.send "https://rally1.rallydev.com/slm/rally.sp#/#{projectId}/detail/#{type}/#{objectId}"
	else
		#do nothing
prettifyDescription = (html_description, cb) ->
	child = exec "echo \"#{html_description}\" | lynx -dump -stdin", (error, stdout, stderr) ->
		return_text = html_description
		if !error
		  return_text = stdout
		cb return_text
		