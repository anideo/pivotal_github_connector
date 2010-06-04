%w[rubygems sinatra xmlsimple rest_client base64].each{|lib| require lib}

USERNAME = 'anideo'
PASSWORD = 'P0l@rb3@r18'

GITHUB_API = "http://github.com/api/v2/xml"
GITHUB_TOKEN = '0b2be480791f5fb45f1adebaffedf301'

use Rack::Auth::Basic do |username, password|
  [username, password] == [USERNAME, PASSWORD]
end

get '/' do  
end

get '/tickets/:repo/:status' do
   response = RestClient.post "#{GITHUB_API}/issues/list/anideo/#{params[:repo]}/#{params[:status]}", {'login' => USERNAME, 'token' => GITHUB_TOKEN}
   hash = XmlSimple.xml_in(response.body)
   @tickets = hash["issue"]
   haml :tickets
end

private

def encode_credentials
  "Basic " + Base64.encode64("#{USERNAME}:#{PASSWORD}")
end
