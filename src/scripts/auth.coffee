# Description:
#   Auth allows you to assign roles to users which can be used by other scripts
#   to restrict access to Hubot commands
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_AUTH_ADMIN
#
# Commands:
#   hubot <user> has <role> role - Assigns a role to a user
#   hubot <user> doesn't have <role> role - Removes a role from a user
#   hubot what role does <user> have - Find out what roles are assigned to a specific user
#   hubot who has admin role - Find out who's an admin and can assign roles
#
# Notes:
#   * Call the method: robot.Auth.hasRole('<user>','<role>')
#   * returns bool true or false
#
#   * the 'admin' role can only be assigned through the environment variable
#   * roles are all transformed to lower case
#
# Author:
#   alexwilliamsca

module.exports = (robot) ->

  admin = process.env.HUBOT_AUTH_ADMIN

  class Auth
    hasRole: (name, role) ->
      user = robot.brain.userForName(name)
      if user? and user.roles?
        if role in user.roles then return true

      return false

  robot.Auth = new Auth

  robot.respond /@?(.+) (has) (["'\w: -_]+) (role)/i, (msg) ->
    name    = msg.match[1].trim()
    newRole = msg.match[3].trim().toLowerCase()

    unless name.toLowerCase() in ['', 'who', 'what', 'where', 'when', 'why']
      user = robot.brain.userForName(name)
      if !user?
        msg.reply "#{name} does not exist"
        return

      user.roles = user.roles or [ ]

      if newRole in user.roles
        msg.reply "#{name} already has the '#{newRole}' role."
      else
        if newRole == 'admin'
          msg.reply "Sorry, the 'admin' role can only be defined in the HUBOT_AUTH_ADMIN env variable."
        else
          myRoles = msg.message.user.roles or [ ]
          if msg.message.user.name.toLowerCase() in admin.toLowerCase().split(',')
            user.roles.push(newRole)
            msg.reply "Ok, #{name} has the '#{newRole}' role."

  robot.respond /@?(.+) (doesn't have|does not have) (["'\w: -_]+) (role)/i, (msg) ->
    name    = msg.match[1].trim()
    newRole = msg.match[3].trim().toLowerCase()

    unless name.toLowerCase() in ['', 'who', 'what', 'where', 'when', 'why']
      user = robot.brain.userForName(name)
      if !user?
        msg.reply "#{name} does not exist"
        return

      user.roles = user.roles or [ ]
      if newRole == 'admin'
        msg.reply "Sorry, the 'admin' role can only be removed from the HUBOT_AUTH_ADMIN env variable."
      else
        myRoles = msg.message.user.roles or [ ]
        if msg.message.user.name.toLowerCase() in admin.toLowerCase().split(',')
          user.roles = (role for role in user.roles when role isnt newRole)
          msg.reply "Ok, #{name} doesn't have the '#{newRole}' role."

  robot.respond /(what role does|what roles does) @?(.+) (have)\?*$/i, (msg) ->
    name = msg.match[2].trim()

    user = robot.brain.userForName(name)
    if !user?
      msg.reply "#{name} does not exist"
      return

    user.roles = user.roles or [ ]

    if name.toLowerCase() in admin.toLowerCase().split(',') then isAdmin = ' and is also an admin' else isAdmin = ''
    msg.reply "#{name} has the following roles: " + user.roles + isAdmin + "."

  robot.respond /who has admin role\?*$/i, (msg) ->
    msg.reply "The following people have the 'admin' role: #{admin.split(',')}"
