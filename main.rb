%w[rubygems sinatra base64 github_api yaml haml].each{|lib| require lib}

CONFIG = YAML::load(File.open('config.yml'))
USERNAME = CONFIG['github_username']
PASSWORD = CONFIG['github_password']

use Rack::Auth::Basic do |username, password|
  [username, password] == [USERNAME, PASSWORD]
end

get '/' do  
end

get '/tickets/:repo/:status' do
   @tickets = GithubAPI::get_issues(params[:repo], params[:status])
   haml :tickets
end

private

def encode_credentials
  "Basic " + Base64.encode64("#{USERNAME}:#{PASSWORD}")
end
