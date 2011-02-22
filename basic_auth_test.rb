%w[main test/unit rack/test base64].each{|lib| require lib}

class MainTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  def test_without_authentication
    get '/'
    assert_equal 401, last_response.status
  end

  def test_with_bad_credentials
    get '/', {}, {'HTTP_AUTHORIZATION' => encode_credentials('go', 'away')}
    assert_equal 401, last_response.status
  end

  def test_with_proper_credentials
    get '/', {}, {'HTTP_AUTHORIZATION'=> encode_credentials('anideo', 'test_password')}
    assert_equal 200, last_response.status
  end

  private

  def encode_credentials(username, password)
    "Basic " + Base64.encode64("#{username}:#{password}")
  end

end