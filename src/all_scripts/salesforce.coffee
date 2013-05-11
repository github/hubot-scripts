# Description:
#   Get connected to the Salesforce.com REST API and do something fun!
#
# Dependencies:
#   None
#
# Configuration:
#   SF_INSTANCE_URL = url of your salesforce instance eg. https://na2.salesforce.com
#	SF_CONSUMER_KEY = consumer key from the Remote Access Setup page in Salesforce
#	SF_CONSUMER_SECRET = consumer secret from the Remote Access Setup page in Salesforce
#	SF_USERNAME = a valid salesforce login
#	SF_PASSWORD = password and security token mashed together
#
# Commands:
#   hubot salesforce account <accountname> - searches for the account by name in Salesforce and displays all matches
#   hubot salesforce query <query> - runs an arbitrary SOQL query and outputs the results
#
# Author:
#   lnediger

sf_instance = process.env.SF_INSTANCE_URL
sf_consumer_key = process.env.SF_CONSUMER_KEY
sf_consumer_secret = process.env.SF_CONSUMER_SECRET
sf_username = process.env.SF_USERNAME
sf_password = process.env.SF_PASSWORD

auth_url = "#{sf_instance}/services/oauth2/token?grant_type=password&client_id=#{sf_consumer_key}&client_secret=#{sf_consumer_secret}&username=#{sf_username}&password=#{sf_password}"
query_url = "#{sf_instance}/services/data/v20.0/query?q="

http = require 'http'
	
	
module.exports = (robot) ->
	robot.respond /salesforce query (.*)$/i, (msg) ->
		query = msg.match[1]
		
		msg.http(auth_url).post() (err, res, body) ->
			oath_token = JSON.parse(body).access_token

			query = encodeURIComponent(query)

			msg.http(query_url + query)
				.headers(Authorization: "OAuth #{oath_token}")
				.get() (err, res, body) ->
					if err
						msg.send "Salesforce says: #{err}"
						return
					
					results = JSON.parse(body)

					if results.records == undefined || results.records.length == 0
						msg.send "No results found!"
					else
						msg.send "Found #{results.records.length} results(s) of type #{results.records[0].attributes.type}"
						for result in results.records
							result_string = ""
							
							for key in Object.keys(result)
								if key != "attributes"
									result_string += "#{key} : #{result[key]}, "
									
							msg.send result_string.substring(0, result_string.length-1)
		
	robot.respond /salesforce account (.*)$/i, (msg) ->		
		acct_name = msg.match[1]
		
		msg.http(auth_url).post() (err, res, body) ->
			oath_token = JSON.parse(body).access_token

			acct_query = "SELECT Owner.Name, Name, Phone, Id From Account where Name = '#{acct_name}'"
			acct_query = encodeURIComponent(acct_query)

			msg.http(query_url + acct_query)
				.headers(Authorization: "OAuth #{oath_token}")
				.get() (err, res, body) ->
					if err
						msg.send "Salesforce says: #{err}"
						return

					accounts = JSON.parse(body)
					if accounts.records == undefined || accounts.records.length == 0
						msg.send "No accounts found!"
					else
						msg.send "Found #{accounts.records.length} Account(s) matching '#{acct_name}'"
						for account in accounts.records
							msg.send "Owner: #{account.Owner.Name}, Name: #{account.Name}, Phone: #{account.Phone}, Id: #{account.Id}"
