require "octokit"
require "json"

=begin
    Add information about your GitHub repository to the jekyll
    site object for use when templating pages.
=end
module Jekyll_GitHub
    class Generator < Jekyll::Generator
        safe true
        priority :highest

        def generate(site)
            projects = Array.new
            client = Octokit::Client.new()
            
            # try fetching the repositories
            begin
                repos = client.repos(site.config["github"])
            rescue
                site.data["projects"] = projects
                return
            end

            # for each repo fetch information
            repos.each do |repo|
                project = Hash.new
                project["title"] = repo.name
                project["description"] = repo.description

                # try fetching an active pages url
                begin
                    pages_info = client.pages(repo.full_name)
                    project["link"] = pages_info.html_url
                rescue
                    project["link"] = repo.html_url
                end

                # try fetching topics about a repo
                begin
                    tags = client.topics(repo.full_name, {:accept => Octokit::Preview::PREVIEW_TYPES[:topics]})
                    project["tech_tags"] = tags.names
                rescue
                    project["tech_tags"] = Array.new
                end

                # add the project to our list
                projects.push(project)
            end

            # store project data against the jekyll site object
            site.data["projects"] = projects
        end
    end
end
