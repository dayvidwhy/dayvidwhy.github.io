#!/usr/bin/env ruby

require 'html-proofer'

# delete and rebuild the site
task :rebuild do
    system "rm -rf _site"
    system "bundle exec jekyll build"
end

# do all of our links work
task :htmlproofer => :rebuild do
    ignored = [
        '#'
    ]
    HTMLProofer.check_directory(
        "./_site", 
        typhoeus: {
            ssl_verifypeer: false,
            timeout: 30
        }, 
        url_ignore: ignored, 
        check_html: true, 
        assume_extension: ".html"
    ).run
end

# spelling in our posts
task :spellcheck do
    Dir.foreach('./_posts') do |item|
        next if item == '.' or item == '..'
        system "mdspell ./_posts/#{item} -c .mdspell"
    end
end

task :default => [:htmlproofer]