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
If something went wrong or the `serve` or `build` command failed initially checking the error message can be helpful but there are some genreal steps to follow to make sure the environment is setup correctly.

Check your ruby installation path.

```bash
which ruby
```

Pointing at the system one?

```bash
brew install ruby
```

You should be able to see that ruby is pointing to the installed one.

```bash
which ruby
/usr/local/opt/ruby/bin/ruby # local/opt is brew
```

Check ruby gems.
```bash
which gem
/usr/local/opt/ruby/bin/gem
```

What version of ruby were we using?
```bash
ruby -v
```


We use bundler to make sure we use gems that go with this project.
```bash
bundle install
bundle exec jekyll serve
```

Can't call `jekyll` binary? Add to `.bash_profile`
```bash
export PATH="/usr/local/opt/ruby/bin:$PATH"
# This is dependant on homebrew install ruby 2.6
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
```