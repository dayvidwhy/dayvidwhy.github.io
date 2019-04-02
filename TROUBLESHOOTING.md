Blog don't want to work?


Remember you don't want to use the system version of ruby.


`which ruby`


Pointing at the system one?


`brew install ruby`


Brew will give you a spiel about how you don't want to mess with the system ruby, it isn't wrong.


You should be able to see that ruby is pointing to the installed one.


`which ruby`
`/usr/local/opt/ruby/bin/ruby`


Check ruby gems.
`which gem`
`/usr/local/opt/ruby/bin/gem`


What version of ruby were we using?
`ruby -v`


Make sure you update `Gemfile` in this repo to that version of ruby.


`bundle install`
`jekyll serve`
Error?
`bundle exec jekyll serve`
Tells ruby you must use the gems specified in this project.


Can't call `jekyll` binary?
```bash
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
```


In your `.bash_profile`.