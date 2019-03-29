source "https://rubygems.org"
ruby '2.4.2'

# get latest versions
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

# gh pages gem
gem 'github-pages', versions['github-pages'], group: :jekyll_plugins
gem "html-proofer"
