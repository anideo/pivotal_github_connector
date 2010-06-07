%w[rubygems pivotal-tracker github_api date].each{|lib| require lib}

CONFIG = YAML::load(File.open('config.yml'))
pivotal_email = CONFIG['pivotal_email']
pivotal_password = CONFIG['pivotal_password']
repos = CONFIG['repos']

module PivotalToGithub
  def self.push_updates(repo, stories)
    stories.each do |story|
      GithubAPI::close_issue(repo, story.other_id) if (story.story_type == 'chore' && story.current_state == 'accepted') || (story.story_type == 'bug' && story.current_state == 'finished') 
    end
  end
end


PivotalTracker::Client.token(pivotal_email, pivotal_password)
@projects = PivotalTracker::Project.all

@projects.each do |project|
  stories = project.activities.all("occurred_since_date=#{DateTime.now - 1}").collect do |activity|
    if activity.event_type == 'story_update'
      story_ids = []
      activity.stories.each{|ac| story_ids << ac.id if ac.other_id }
      story_ids.compact
    end
  end
  PivotalToGithub::push_updates(repos[project.name], project.stories.all(:id => stories.compact.flatten.uniq.join(',')))
end
