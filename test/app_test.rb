require 'test_helper'
OUTER_APP = Rack::Builder.parse_file('config.ru').first
class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_welcome_success
    get '/api/v1/welcome'
    data = JSON.parse(last_response.body)
    assert 200,last_response.status
    assert_equal "welcome to integration xr-sinatra", data["message"]
  end
end
