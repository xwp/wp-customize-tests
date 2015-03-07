There is a `customize` test group for PHPUnit

```
phpunit --group customize
```

This repo provides some additional features tailored for running tests for the Customizer,
specifically support for generating code coverage reports (see [example](http://xwp.github.io/wp-customize-tests/)).

Clone this repo as a subdirectory for your `wordpress-develop` repo:

```sh
cd wordpress-develop
git clone https://github.com/xwp/wp-customize-tests.git wp-customize-tests
```

Then you can run unit tests specific to the Customizer via:

```sh
wp-customize-tests/run.sh
```

And then open `wp-customize-tests/coverage-html/index.html` to see the report.


