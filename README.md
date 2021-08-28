## Quick start
Quick steps to get the blog up and running.

```bash
git clone git@github.com:dayvidwhy/dayvidwhy.github.io.git
cd dayvidwhy.github.io
bundle install
bundle exec jekyll serve
```

## Goals
Make use of the Jekyll blog engine, get my feet wet with ruby and make use of liquid templating. Jekyll is a static site generator that produces plain html from several template pages that can be deployed to most hosting providers since it is just HTML, CSS and JavaScript

## Technologies
* Ruby
* SCSS
* JavaScript
* Liquid
* Jekyll

## Tests
A `Rakefile` is provided that runs `html-proofer` to validate the HTML in the built `_site` directory ensuring outgoing links work and other good practices are followed.
```bash
bundle exec rake
```

## Troubleshooting
If something went wrong or the `serve` or `build` command failed initially checking the error message can be helpful but there are some genreal steps to follow to make sure the environment is setup correctly. I currently use ruby `2.7.4` so installing `ruby@2.7` with homebrew is my preference. The project will also run with ruby `3.0.2` as of currently checking if you prefer that.

Check your ruby installation path.

```bash
which ruby
```

Pointing at the system one?

```bash
brew install ruby@2.7
```

You should be able to see that ruby is pointing to the installed one.

```bash
which ruby gem
/usr/local/opt/ruby@2.7/bin/ruby
/usr/local/opt/ruby@2.7/bin/gem
```

Confirm the version of ruby
```bash
ruby -v
ruby 2.7.4
```

We use bundler to make sure we use gems that go with this project.
```bash
bundle install
bundle exec jekyll serve
```

You may need these added to your `.bash_profile` or other file run when you open a terminal.
```bash
export PATH="/usr/local/opt/ruby@2.7/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby@2.7/lib"
export CPPFLAGS="-I/usr/local/opt/ruby@2.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby@2.7/lib/pkgconfig"
```
