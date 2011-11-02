# Get all bugs from JIRA assigned to user
#
# To configure, export the following shell variables
# HUBOT_JIRA_DOMAIN
# HUBOT_JIRA_USER
# HUBOT_JIRA_PASSWORD
#
# list my bugs - Retrieve the list of all a user's bugs from JIRA ('my' is optional)
# list my bugs about <searchterm> - Retrieve list of all a user's bugs from JIRA where the summary or description field contains <phrase> ('my' is optional)
# list my <priority> priority bugs 	- Retrieve the list of a user's <priority> priority bugs from JIRA ('my' is optional)
# list my <priority> priority bugs about <phrase> - Retrieve list of all a user's <priority> priority bugs from JIRA where the summary or description field contains <phrase> ('my' is optional)
#
module.exports = (robot) ->

	robot.respond /list( my)?( (blocker|high|medium|minor|trivial)( priority)?)? bugs( about (.*))?/i, (msg) ->
		username = if msg.match[1] then msg.message.user.email.split('@')[0] else null
		msg.send "Searching for bugs..."
		getBugs msg, username, msg.match[3], msg.match[6], (bugList) ->
			msg.send bugList

getBugs = (msg, assignee, priority, phrase, callback) ->
	user = if assignee? then ' and assignee="' + assignee + '"' else ''
	prio = if priority? then ' and priority=' + priority else ''
	search = if phrase? then ' and (summary~"' + phrase + '" or description~"' + phrase + '")' else ''

	username = process.env.HUBOT_JIRA_USER
	password = process.env.HUBOT_JIRA_PASSWORD
	domain = process.env.HUBOT_JIRA_DOMAIN

	# do some error handling
	unless username
		msg.send "HUBOT_JIRA_USER environment variable must be set to a valid JIRA user's username."
		return
	unless password
		msg.send "HUBOT_JIRA_PASSWORD environment variable must be set to a valid JIRA user's password."
		return
	unless domain
		msg.send "HUBOT_JIRA_DOMAIN environment variables must be set to a valid <ORG>.jira.com domain."
		return

	path = '/rest/api/latest/search'
	url = "https://" + domain + path
	queryString = 'issueType=bug and status!=closed' + user + prio + search + ' order by createddate'
	auth = "Basic " + new Buffer(username + ':' + password).toString('base64')

	getJSON msg, url, queryString, auth, (err, json) ->
 		if err
 			msg.send "error getting bug list from JIRA"
 			return
 		if json.total? and (json.total==0 or json.total=="0")
 			msg.send "No bugs, or you don't have access to see the bugs."
 		bugList = []
 		for issue in json.issues
 			getJSON msg, issue.self, null, auth, (err, details) ->
 				if err
	 				msg.send "error getting bug details from JIRA"
	 				return
 				bugList.push( {key: details.key, summary: details.fields.summary.value} )
 				msg.send(formatBugList(bugList, domain)) if bugList.length == json.issues.length
 		
formatBugList = (bugArray, domain) ->
	formattedBugList = ""
	for bug in bugArray
		formattedBugList += bug.summary + " -> https://" + domain + "/browse/" + bug.key + "\n"
	return formattedBugList

getJSON = (msg, url, query, auth, callback) ->
	msg.http(url)
		.header('Authorization', auth)
		.query(jql: query)
		.get() (err, res, body) ->
			callback( err, JSON.parse(body) )
