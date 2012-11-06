# hubot-scripts

These are a collection of community scripts for [hubot][hubot], a chat bot for
your company.


## Discovering

Check out the [hubot-script-catalog][script-catalog] for a list and description
of all the available scripts.

## Installing

Once you have Hubot installed, you can drop new scripts from this repository
right into your generated Hubot installation. Just put them in `scripts`, add
the new scripts to the `hubot-scripts.json` file.

Any third-party dependencies for scripts need the addition of your `package.json`
otherwise a lot of errors will be thrown during the start up of your hubot. You
can find a list of dependencies for a script in the documentation header at the
top of the script.

Restart your robot, and you're good to go.

All the scripts in this repository are located in [`src/scripts`][src-scripts].

## Writing

Want to write your own Hubot script? The best way is to take a look at an
[existing script][example-script] and see how things are set up. Hubot scripts
are written in CoffeeScript, a higher-level implementation of JavaScript.

You'll also want to [add tests][hubot-script-tests] for your script; no one
likes untested code. It makes Hubot sad.

Additionally, it's extremely helpful to add [TomDoc][tomdoc] to the top of each
file. (Check out [an example][example-script-doc]). We'll pull out the commands
from those lines and display them in the generic, robot-wide `hubot help`
command.

Please note we're no longer including external dependencies in the
`package.json`, so should you wish to include them please include the package
name and required version in the TomDoc comments at the top of your script.

## Documentation

We're now requiring all scripts in hubot-scripts to contain a documentation
header so people know every thing about the script.

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
