require "octokit"
require "dotenv/load"

=begin
    Add information about your GitHub repository to the jekyll
    site object for use when templating pages.

    Final output looks like:
        site.data.projects = [
            {
                title,
                description,
                link,
                tech_tags
            }
        ]
    
    Using liquid you can loop over and use those variables:
        {% for project in site.data.projects %}
            ...
        {% endfor %}

=end
module Jekyll_GitHub
    class Generator < Jekyll::Generator
        safe true
        priority :highest

        # main entry point
        def generate(site)
            # instantiates our octokit helper
            @client = Octokit::Client.new(:access_token => ENV["INPUT_TOKEN"])

            # storage for our projects
            projects = Array.new

            # grab our list of repositories
            repos = fetchRepositories(site.config["github"])

            # for each repo fetch details
            repos.each do |repo|
                projects.push(fetchRepositoryDetails(repo))
            end

            # convert repo languages into
            site.data["programming_languages"] = aggregateLanguages(projects)

            # store project data against the jekyll site object
            site.data["projects"] = projects
        end

        # receives list of projects, each has 'languages' key
        # languages are name => bytecount pairs
        def aggregateLanguages (projects)
            allLanguages = Array.new

            projects.each do |project|
                project['languages'].each do |language|
                    allLanguages.push(language[0])
                end
            end

            allLanguages.uniq
        end

        # gets repositories for a specific user
        def fetchRepositories (user)
            begin
                # try fetching the repositories
                repos = @client.repos(user)
            rescue
                # if the fetch failed just set an empty array
                repos = Array.new
            end

            # return our set of repositories
            repos
        end

        # returns a Hash of information for a repo
        def fetchRepositoryDetails (repo)
            project = Hash.new

            # title of the repository
            project["title"] = repo.name

            # description of the repo, includes emojis in response
            project["description"] = repo.description

            allLanguages = Array.new
            begin
                project["languages"] = @client.languages(repo.full_name)
            rescue
                # do nothing
                project["languages"] = nil
            end

            # try fetching an active github pages url for the repo
            begin
                pages_info = @client.pages(repo.full_name)
                project["link"] = pages_info.html_url
            rescue
                # fall back to the url of the repository
                project["link"] = repo.html_url
            end

            # try fetching topics about a repo
            begin
                # the topics endpoint requires a certain header to suppress a warning
                tags = @client.topics(repo.full_name, {:accept => Octokit::Preview::PREVIEW_TYPES[:topics]})
                project["tech_tags"] = tags.names
            rescue
                project["tech_tags"] = Array.new
            end
            project
        end
    end
end
