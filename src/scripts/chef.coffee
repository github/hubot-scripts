# Description:
#   Allows hubot to run commands using chef/knife.
#
# Dependencies:
#   chef somehow installed on the box
#
# Configuration:
#   knife.rb should be configured to run
#
# Commands:
#   hubot converge <server> - chef: Runs chef-client on node
#   hubot converge-environment <environment> - chef: Runs chef-client across an environment
#   hubot environment list -  chef: Lists all environments on chef server
#   hubot knife node show <name> - chef: Display node run_list et al
#   hubot knife role show <name> - chef: Display role configurations et al
#   hubot knife client show <name> - chef: Display client configurations et al
#   hubot nodes list - chef: Lists all nodes on chef server
#   hubot nodes status - chef: Get knife status of all nodes
#   hubot uptime <server> - chef: Prints uptime per node
#
# Author:
#   jj.asghar@peopleadmin.com

module.exports = (robot) ->
  robot.respond /nodes list$/i, (msg) ->
    spawn = require('child_process').spawn

    server = msg.match[1]
    command = "knife node list"

    msg.send "Listing nodes..."

    @exec = require('child_process').exec

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /node status$/i, (msg) ->
    spawn = require('child_process').spawn

    server = msg.match[1]
    command = "knife status"

    msg.send "Getting statuses of all nodes..."

    @exec = require('child_process').exec

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /environment list$/i, (msg) ->
    spawn = require('child_process').spawn

    server = msg.match[1]
    command = "knife node list"

    msg.send "Listing environments..."

    @exec = require('child_process').exec

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr


  robot.respond /knife (node|role|client) show (.*)$/i, (msg) ->
    spawn = require('child_process').spawn

    subcmd = msg.match[1]
    name = msg.match[2]
    command = "knife #{subcmd} show #{name}"

    msg.send "Running: #{command}"

    @exec = require('child_process').exec

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /uptime (.*)$/i, (msg) ->
    spawn = require('child_process').spawn
    server = msg.match[1]

    command = "knife ssh name:#{server} 'uptime'"

    msg.send "Checking #{server} for uptime..."

    @exec = require('child_process').exec

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /converge (.*)$/i, (msg) ->
    server = msg.match[1]

    @exec = require('child_process').exec

    command = "knife ssh --attribute ipaddress --no-color name:#{server} 'sudo chef-client'"

    msg.send "Converging #{server}."

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /converge-environment (.*)$/i, (msg) ->
    # environment = msg.match[1]
    # @exec = require('child_process').exec
    # command = "knife ssh --no-color --attribute ipaddress chef_environment:#{environment} 'sudo chef-client'"

    msg.send "Configuring #{environment}....nope just kidding man, you have balls..."

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr
