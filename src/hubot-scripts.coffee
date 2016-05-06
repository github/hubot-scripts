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
    robot.logger.warning "#{filename} in hubot-scripts.json has moved to its own package. Remove it from hubot-scripts.json and see #{replacement} for how to install the new package."
    deprecatedScriptsUsed.push(filename)
  else
    inferredPackageName = "hubot-#{filename.replace('.coffee', '')}"
    robot.logger.warning "#{filename} in hubot-scripts.json has been deprecated without a known replacement yet. You can try https://www.npmjs.com/search?q=#{inferredPackageName} or https://github.com/search?q=#{inferredPackageName}&type=Repositories or your favorite search engine. If you find a replacement or can't find a replacement, please leave a comment on https://github.com/github/hubot-scripts/issues/1641 with what you found."


module.exports = HubotScripts
