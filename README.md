# hubot-scripts

These are a collection of community scripts for
[Hubot](https://github.com/github/hubot), a chat bot for your company.

## Installing

Once you have Hubot installed, you can drop new scripts from this repository
right into your generated Hubot installation. Just put them in `scripts`,
restart your robot, and you're good to go.

All the scripts in this repository are located in
[`src/scripts`](https://github.com/github/hubot-scripts/tree/master/src/scripts).

## Writing

Want to write your own Hubot script? The best way is to take a look at an
[existing script](https://github.com/github/hubot-scripts/blob/master/src/scripts/tweet.coffee)
and see how things are set up. Hubot scripts are written in CoffeeScript, a
higher-level implementation of JavaScript.

You'll also want to [add tests](https://github.com/github/hubot-scripts/blob/master/test/tests.coffee)
for your script; no one likes untested code. It makes Hubot sad.

Additionally, it's extremely helpful to add [TomDoc](http://tomdoc.org) to the
top of each file. (Check out [an example](https://github.com/github/hubot-scripts/blob/master/src/scripts/speak.coffee#L1-5)).
We'll pull out the commands from those lines and display them in the generic,
robot-wide `hubot help` command.

## Scripts

### Spin me

__Format:__

    spin me <query> - Returns a spun version of the input.

__Input:__

    @yourbot spin me {Hi there|Greetings|Hi|Hello|Hello There}{!|,}

    I {really|simply|totally} {love|respect|admire} your {blog|article|post|opinion} and {will tell all my friends about it|will be back again tomorrow|also the design of your website}.

    {Thanks|Thank you|Cheers|Bye for now}!

__Output:__

    Greetings!

    I simply admire your blog and also the design of your website.

    Cheers!