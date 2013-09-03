It's now preferred that if you are able to, you should release your script as
part of an npm package built for Hubot.

For an example you can take a look at
https://github.com/hubot-scripts/hubot-example which is an example package that
you can use to create your own and publish to npm.

We can also fork your Hubot Script Package to the Hubot Scripts organization so
people can easily find it and file issues and pull requests. More information
can be found in the https://github.com/hubot-scripts/packages repository.

If you would still prefer to add your script to this repository then please
follow the guidelines below.

Some things that will increase the chance that your pull request is accepted:

  * Use CoffeeScript [idioms](http://arcturo.github.io/library/coffeescript/04_idioms.html)
    and [style guide](https://github.com/polarmobile/coffeescript-style-guide)
  * Update the documentation, the surrounding one, examples elsewhere, guides,
    whatever is affected by your contribution
  * Include any information that would be relevant to reproducing bugs, use
    cases for new features, etc.
  * Impact on existing usesrs if modifying a script.

Syntax:

  * Two spaces, no tabs.
  * No trailing whitespace. Blank lines should not have any space.
  * Prefer `and` and `or` over `&&` and `||`
  * Prefer single quotes over double quotes unless interpolating strings.
  * `MyClass.myMethod(my_arg)` not `myMethod( my_arg )` or `myMethod my_arg`.
  * `a = b` and not `a=b`.
  * Follow the conventions you see used in the source already.
