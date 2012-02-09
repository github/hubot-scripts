fs   = require 'fs'
path = require 'path'


# sets up hooks to persist the brain into file.
module.exports = (robot) ->
  brainPath = process.env.FILE_BRAIN_PATH or '/var/hubot'
  brainPath = path.join brainPath, 'brain-dump.json'

  try
    data = fs.readFileSync brainPath, 'utf-8'
    if data
      robot.brain.mergeData JSON.parse(data)
  catch error
      console.log('Unable to read file', error) unless error.code is 'ENOENT'

  robot.brain.on 'save', (data) ->
    fs.writeFileSync brainPath, JSON.stringify(data), 'utf-8'
