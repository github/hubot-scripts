# Description:
#   Simple Python Package Index querying using XMLRPC API.
#
# Dependencies:
#   "pypi": ""
#
# Configuration:
#   HUBOT_PYPI_URL (defaults to http://pypi.python.org/pypi)
#
# Commands:
#   hubot show latest from pypi for <package> - Shows latest version of Python package registered at PyPI
#   hubot show total downloads from pypi for <package> - Shows total number of downloads across all versions of Python package registered at PyPI
#
# Author:
#   lukaszb

pypi = require "pypi"

createClient = ->
    return new pypi.Client process.env.HUBOT_PYPI_URL or "http://pypi.python.org/pypi"


showLatestPackage = (msg, pkg) ->
    client = createClient()
    client.getPackageReleases pkg, (versions) ->
        if versions.length
            latestVersion = versions.sort()[versions.length - 1]
            msg.send "Latest version of #{pkg} is #{latestVersion}"

showTotalDownloads = (msg, pkg) ->
    client = createClient()
    client.getPackageReleases pkg, (versions) ->
        totalDownloads = 0
        todo = versions.length
        for version in versions
            client.getReleaseDownloads pkg, version, (downloads) ->
                for count in (e[1] for e in downloads)
                    totalDownloads += count
                todo -= 1
                if todo == 0
                    msg.send "Total downloads of #{pkg}: #{totalDownloads}"

module.exports = (robot) ->

    robot.respond /show latest from pypi for (.*)/i, (msg) ->
        pkg = msg.match[1]
        showLatestPackage msg, pkg

    robot.respond /show total downloads from pypi for (.*)/i, (msg) ->
        pkg = msg.match[1]
        showTotalDownloads msg, pkg
