# Description:
#   None
#
# Dependencies:
#   "level" : "latest"
#
# Configuration:
#   If not provided, 'LEVEL_BRAIN_PATH' will default to 'lvldb.hubot'.
#   e.g. 'LEVEL_BRAIN_PATH=/path/to/where/you/want/the/db ./bin/hubot'
#
# Commands:
#   None
#
# Authors:
#   lordhelmut

Level = require "level"

module.exports = (robot) ->
  prefix = 'hubot'
  db = Level(process.env.LEVEL_BRAIN_PATH or './lvldb.hubot', {valueEncoding:'json'})

  db.get "#{prefix}:storage", (err, reply) ->
    if err
      robot.logger.info if err.notFound "\n\n----- no data found!! -----\n"
      throw err
    else if reply
      robot.brain.mergeData JSON.parse(reply)
      robot.logger.info "\n\n----- Data for #{prefix} brain retrieved from LevelDB ----\n"

  robot.brain.on 'save', (data) ->
    #robot.logger.info "\n\n----- Save Brain running ----- \n"
    db.put "#{prefix}:storage", JSON.stringify(data)

  robot.brain.on 'close', (data) ->
    robot.logger.info "\n\n----- close Brain running ----- \n"
