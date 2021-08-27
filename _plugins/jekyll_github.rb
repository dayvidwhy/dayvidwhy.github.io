require 'octokit'
require 'json'

module Jekyll_GitHub
    class Generator < Jekyll::Generator
        safe true
        priority :highest

        def generate(site)
            user = 'dayvidwhy'
            client = Octokit::Client.new()
            repos = client.repos user
            projects = Array.new
            repos.each do |repo|
                project = Hash.new
                project['title'] = repo.name
                project['description'] = repo.description
                begin
                    pages_info = client.pages repo.full_name
                    project["link"] = pages_info.html_url
                rescue
                    project['link'] = repo.html_url
                end
                tags = client.topics repo.full_name
                project['tech_tags'] = tags.names
                project['developer'] = 'Web Developer'
                project['meta'] = "Application Project"
                project["theme_colour"] = "inherit"
                projects.push(project)
            end
            site.data["projects"] = projects
        end
    end
end
