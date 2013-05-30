# Hubot Scripts

These are a collection of community scripts for [hubot][hubot], a chat bot for
your company.

## Installing

If you've followed the documentation for getting a hubot up and running you
should have `hubot-scripts` already set up.

## Updating

If you want to update `hubot-scripts` to the latest version you will need to
edit the specified version in your hubots `package.json` to match the latest
available version. Now when you push to Heroku or `npm install` it will update
the `hubot-scripts` package to the specified version.

## Hacking

Want to write your own Hubot script? The best way is to take a look at an
existing script and see how things are set up. Hubot scripts are written in
CoffeeScript, a higher-level implementation of JavaScript.

Additionally, it's extremely helpful to add TomDoc to the top of each file.
(Check out an example). We'll pull out the commands from those lines and display
them in the generic, robot-wide hubot help command.

Please note we're no longer including external dependencies in the package.json,
so should you wish to include them please include the package name and required
version in the TomDoc comments at the top of your script.

## Contributing

We are deprecating `hubot-scripts` in favor of external script packages which
make developing, testing and using scripts with hubot a lot easier.

## License

Copyright (c) 2013 GitHub, Inc. See the LICENSE file for license rights and
limitations (MIT).
