Path = require 'path'
Fs   = require 'fs'

HubotScripts = {}

replacementsPath = Path.resolve(__dirname, "..", "replacements.json")

if Fs.existsSync(replacementsPath)
  data = Fs.readFileSync(replacementsPath)
  if data.length > 0
    try
      replacements = JSON.parse data
    catch err
      console.error "Error parsing JSON data from hubot-scripts's replacements.json: #{err}"
      process.exit(1)

HubotScripts.replacements = replacements ?= {}

HubotScripts.deprecatedScriptsUsed = deprecatedScriptsUsed =  []
HubotScripts.deprecate = (robot, filename) ->
  filename = Path.basename(filename)

  replacement = replacements[filename]
  if replacement
    robot.logger.warning "#{filename} in hubot-scripts.json has moved to its own package. Remove it from hubot-scripts.json and see #{replacement} for how to install the new version"
    deprecatedScriptsUsed.push(filename)

module.exports = HubotScripts
