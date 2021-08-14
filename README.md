# Getting Started
<img style="display: inline-block" src="./images/small.jpg" data-canonical-src="./images/small.jpg" width="150" />

My personal blog powered by Jekyll.

## What is this
This is where I hope to layout some of my thoughts while progressing into the tech industry.

## Goals and Requirements
Make use of the Jekyll templating engine to get my feet wet with ruby using liquid templating.

## Technologies
* HTML5
* SCSS
* JavaScript
* Liquid Templating
* Jekyll

## Contributing
I do not accept contributions to this project.

# Troubleshooting


Check your ruby installation path.

```bash
which ruby
```

Pointing at the system one?

```bash
brew install ruby
```

Brew will give you a spiel about how you don't want to mess with the system ruby. You should be able to see that ruby is pointing to the installed one.

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
`ruby -v`


Make sure you update `Gemfile` in this repo to that version of ruby.

```bash
bundle install
jekyll serve
# Error?
bundle exec jekyll serve
# Tells ruby you must use the gems specified in this project.
```

Can't call `jekyll` binary? Add to `.bash_profile`
```bash
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
```