source "https://rubygems.org"
ruby RUBY_VERSION

# get latest versions
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

# gh pages gem
gem 'github-pages', versions['github-pages'], group: :jekyll_plugins

# other plugins
group :jekyll_plugins do
    gem "html-proofer"
end
