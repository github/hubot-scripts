# Description:
#   Post gitlab related events using gitlab hooks to IRC
#
# Dependencies:
#   None
#
# Configuration:
#   GITLAB_CHANNEL
#
# Commands:
#   None
#
# URLS:
#   /gitlab/system
#   /gitlab/web
#
# Dependencies:
#   "querystring" : "0.1.0"
#
# Author:
#   omribahumi

querystring = require 'querystring'

module.exports = (robot) ->
  gitlabChannel = process.env.GITLAB_CHANNEL or "#gitlab"

  bold = (text) ->
    "\x02" + text + "\x02"
  underline = (text) ->
    "\x1f" + text + "\x1f"

  trim_commit_url = (url) ->
    url.replace(/(\/[0-9a-f]{9})[0-9a-f]+$/, '$1')

  handler = (type, req, res) ->
    parameters = querystring.parse(req._parsedUrl.query)
    hook = req.body

    targets = if parameters.targets then gitlabChannel + ',' + parameters.targets else gitlabChannel
    switch type
      when "system"
        switch hook.event_name
          when "project_create"
            robot.send room: targets, "Yay! New gitlab project #{bold(hook.name)} created by #{bold(hook.owner_name)} (#{bold(hook.owner_email)})"
          when "project_destroy"
            robot.send room: targets, "Oh no! #{bold(hook.owner_name)} (#{bold(hook.owner_email)}) deleted the #{bold(hook.name)} project"
          when "user_add_to_team"
            robot.send room: targets, "#{bold(hook.project_access)} access granted to #{bold(hook.user_name)} (#{bold(hook.user_email)}) on #{bold(hook.project_name)} project"
          when "user_remove_from_team"
            robot.send room: targets, "#{bold(hook.project_access)} access revoked from #{bold(hook.user_name)} (#{bold(hook.user_email)}) on #{bold(hook.project_name)} project"
          when "user_create"
            robot.send room: targets, "Please welcome #{bold(hook.name)} (#{bold(hook.email)}) to Gitlab!"
          when "user_destroy"
            robot.send room: targets, "We will be missing #{bold(hook.name)} (#{bold(hook.email)}) on Gitlab"
      when "web"
        message = []
        branch = hook.ref.split("/")[2..].join("/")
        # if the ref before the commit is 00000, this is a new branch
        if /^0+$/.test(hook.before)
            message.push "Gitlab #{bold(hook.repository.name)} (#{underline(hook.repository.url)}): #{bold(hook.user_name)} pushed a new branch: #{bold(branch)}"
        else
            message.push "Gitlab #{bold(hook.repository.name)} (#{underline(hook.repository.url)}): #{bold(hook.user_name)} pushed #{bold(hook.total_commits_count)} commits to #{bold(branch)}:"
            for i, commit of hook.commits
              commit_message = commit.message.split("\n")[0]
              message.push "    * #{commit_message} (#{underline(trim_commit_url(commit.url))})"
            if hook.total_commits_count > 1
                message.push "Entire diff: #{underline(hook.repository.url + '/compare/' + hook.before.substr(0,9) + '...' + hook.after.substr(0,9))}"
        message = message.join("\n")
        robot.send room: targets, message

  robot.router.post "/gitlab/system", (req, res) ->
    handler "system", req, res
    res.end ""

  robot.router.post "/gitlab/web", (req, res) ->
    handler "web", req, res
    res.end ""

