# Description:
#   Search for a job and profit!
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_AUTHENTIC_JOBS_API_KEY
#
# Commands:
#   hubot find me a <technology> job in <location>
#
# Author:
#   sleekslush

module.exports = (robot) ->
  robot.respond /find me a (.* )?job( in (.+))?/i, (msg) ->
    [keywords, location] = [msg.match[1], msg.match[3]]

    params =
      api_key: process.env.HUBOT_AUTHENTIC_JOBS_API_KEY
      method: "aj.jobs.search"
      perpage: 100
      format: "json"

    params.keywords = keywords if keywords?
    params.location = location if location?

    msg
      .http("http://www.authenticjobs.com/api/")
      .query(params)
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send get_a_job msg, response

get_a_job = (msg, response) ->
  listings = response.listings.listing

  if not listings.length
    return "Sorry, I couldn't find you a job. Guess you're going to be broke for a while!"

  random_listing = msg.random listings

  "#{random_listing.title} at #{random_listing.company.name}. Apply at #{random_listing.apply_url or random_listing.apply_email}"
