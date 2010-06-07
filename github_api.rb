%w[rubygems octopi].each{|lib| require lib}
include Octopi

CONFIG = YAML::load(File.open('config.yml'))
GITHUB_API = CONFIG['github_api']
GITHUB_TOKEN = CONFIG['github_token']
GITHUB_USERNAME = CONFIG['github_username']

module GithubAPI
    
  def self.get_issues(repo, status)
    authenticated_with :login => GITHUB_USERNAME, :token => GITHUB_TOKEN do 
      Issue.find_all(:user => GITHUB_USERNAME, :repo => repo, :state => status)
    end
  end
  
  def self.close_issue(repo, issue_no)
    authenticated_with :login => GITHUB_USERNAME, :token => GITHUB_TOKEN do 
      issue = Issue.find(:user => GITHUB_USERNAME, :repo => repo, :number => issue_no)
      issue.close!
    end
  end
  
  def self.reopen_issue(repo, issue_no)
    authenticated_with :login => GITHUB_USERNAME, :token => GITHUB_TOKEN do 
      issue = Issue.find(:user => GITHUB_USERNAME, :repo => repo, :number => issue_no)
      issue.reopen!
    end
  end
  
  def self.add_issue_comment(repo, issue_no, comment)
    authenticated_with :login => GITHUB_USERNAME, :token => GITHUB_TOKEN do 
      issue = Issue.find(:user => GITHUB_USERNAME, :repo => repo, :number => issue_no)
      issue.comment(comment)
    end
  end
  
end


