# hubot-scripts

These are a collection of community scripts for [hubot][hubot], a chat bot for
your company.

**Imporant**: this repository is no longer accepting new scripts. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

There is a new system for distributing scripts, and adding them to your own hubot. Locate the appropriate script in the [hubot-scripts organization](https://github.com/hubot-scripts) or on [npm tagged as *hubot-scripts*](https://www.npmjs.org/browse/keyword/hubot-scripts), and follow the script's documentation. In general, this will be something like:

1. Add a line to external-scripts.json
2. Add a line to package.json
3. Add environment variables, depending on the script

## Discovering

Check out the [hubot-script-catalog][script-catalog] for a list and description
of all the available scripts.

## Installing

Once you have Hubot installed, you should already have `hubot-scripts`
installed. Check `package.json` to be sure. If that is the case, you update
`hubot-scripts.json` to list any scripts from this repository you want to load.
The default `hubot-scripts.json` looks like:

    ["redis-brain.coffee", "shipit.coffee"]

If you update `hubot-scripts` in `package.json`, you will automatically get
updates to your scripts listed here.

Alternatively, you can copy files from this repository into your `scripts`
directory. Note that you would not get updates from the `hubot-scripts`
repository unless you copy them yourself.

Any third-party dependencies for scripts need the addition of your
`package.json` otherwise a lot of errors will be thrown during the start up of
your hubot. You can find a list of dependencies for a script in the
documentation header at the top of the script.

Restart your robot, and you're good to go.

All the scripts in this repository are located in [`src/scripts`][src-scripts].

## Writing

Want to write your own Hubot script? The best way is to take a look at an
[existing script][example-script] and see how things are set up. Hubot scripts
are written in CoffeeScript, a higher-level implementation of JavaScript.

Additionally, it's extremely helpful to add [TomDoc][tomdoc] to the top of each
file. (Check out [an example][example-script-doc]). We'll pull out the commands
from those lines and display them in the generic, robot-wide `hubot help`
command.

Please note we're no longer including external dependencies in the
`package.json`, so should you wish to include them please include the package
name and required version in the TomDoc comments at the top of your script.

## Documentation

We're now requiring all scripts in hubot-scripts to contain a documentation
header so people know everything about the script.

```coffeescript
# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>
```

If you have nothing to fill in for a section you should include `None` in that
section. Empty sections which are optional should be left blank. A script will
be required to fill out the documentation before being merged into the
repository.

[hubot]: https://github.com/github/hubot
[script-catalog]: http://hubot-script-catalog.herokuapp.com
[src-scripts]: https://github.com/github/hubot-scripts/tree/master/src/scripts
[tomdoc]: http://tomdoc.org
[example-script]: https://github.com/github/hubot-scripts/blob/master/src/scripts/tweet.coffee
[hubot-script-tests]: https://github.com/github/hubot-scripts/blob/master/test/tests.coffee
[example-script-doc]: https://github.com/github/hubot-scripts/blob/master/src/scripts/speak.coffee#L1-5
