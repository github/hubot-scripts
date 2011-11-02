# Simple Python Package Index querying using XML-RPC API.
#
# Set HUBOT_PYPI_URL to custom PyPI server if you like. Defaults to http://pypi.python.org/pypi
#
# show latest from pypi for <package> - Shows latest version of Python package registered at PyPI
# show total downloads from pypi for <package> - Shows total number of downloads accross all versions of Python package registered at PyPI

pypi = require "pypi"


createClient = ->
    return new pypi.Client process.env.HUBOT_PYPI_URL or "http://pypi.python.org/pypi"


showLatestPackage = (msg, package) ->
    client = createClient()
    client.getPackageReleases package, (versions) ->
        if versions.length
            latestVersion = versions.sort()[versions.length - 1]
            msg.send "Latest version of #{package} is #{latestVersion}"

showTotalDownloads = (msg, package) ->
    client = createClient()
    client.getPackageReleases package, (versions) ->
        totalDownloads = 0
        todo = versions.length
        for version in versions
            client.getReleaseDownloads package, version, (downloads) ->
                for count in (e[1] for e in downloads)
                    totalDownloads += count
                todo -= 1
                if todo == 0
                    msg.send "Total downloads of #{package}: #{totalDownloads}"


module.exports = (robot) ->

    robot.respond /show latest from pypi for (.*)/i, (msg) ->
        package = msg.match[1]
        showLatestPackage msg, package

    robot.respond /show total downloads from pypi for (.*)/i, (msg) ->
        package = msg.match[1]
        showTotalDownloads msg, package

