# Description:
#   Save the brain on jsonblob.com.
#
# Configuration:
#   JSONBLOB_URL
#
# Commands:
#   None
#
# Notes:
#   Create a blank blob by the following command or via jsonblob.com
#   curl -i -d '{}' -H "Content-Type: application/json" -H "Accept: application/json" http://jsonblob.com/api/jsonBlob
#   Put the URL returned (in Location) into JSONBLOB_URL
# 
# Author:
#   captn3m0

module.exports = (robot) ->
  #Get the data from Jsonblob's api for the first time
  robot.http(process.env.JSONBLOB_URL).get() (err, res, body) ->
    robot.brain.mergeData JSON.parse(body)

  robot.brain.on 'save', (data = {}) ->
    robot.http(process.env.JSONBLOB_URL)
    .header("Accept", "application/json")
    .header("Content-Type","application/json")
    .put(JSON.stringify(data)) (err, res, body) ->
      console.log err if err
