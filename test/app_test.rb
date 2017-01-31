require 'test_helper'
OUTER_APP = Rack::Builder.parse_file('config.ru').first
class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  # Test get/:currency endpoint
  def test_get_currency_succesful
    get '/', :currency => 'COP'
    assert last_response.ok?
    assert 200, last_response.status
    assert 'image/png', last_response.header["Content-Type"]
  end

  def test_get_currency_not_found
    get '/', :currency => 'ABC'
    assert last_response.ok?
    assert 404, last_response.status
    assert 'image/png', last_response.header["Content-Type"]
  end


  # Test get/:base/to/:currency endpoint
  def test_get_currency_base_succesful
    get '/USD/to/COP'
    assert last_response.ok?
    assert 200, last_response.status
    assert 'image/png', last_response.header["Content-Type"]
  end

  def test_get_currency_base_json_succesful
    get '/USD/to/COP.json'
    data = JSON.parse(last_response.body)
    assert last_response.ok?
    assert 200, last_response.status
    assert 'application/json', last_response.header["Content-Type"]
    refute_empty data["message"]
  end

  def test_get_currency_base_html_succesful
    get '/USD/to/COP.html'
    assert last_response.ok?
    assert 200, last_response.status
    assert 'text/html', last_response.header["Content-Type"]
    refute_nil last_response.body
  end

  def test_get_currency_base_txt_succesful
    get '/USD/to/COP.txt'
    assert last_response.ok?
    assert 200, last_response.status
    assert 'text/plain', last_response.header["Content-Type"]
    refute_empty last_response.body
  end

  def test_get_currency_base_not_found
    get '/DOG/to/ABC'
    assert !last_response.ok?
    assert 404, last_response.status
    assert 'image/png', last_response.header["Content-Type"]
  end

  def test_get_currency_base_json_not_found
    get '/DOG/to/ABC.json'
    data = JSON.parse(last_response.body)
    assert !last_response.ok?
    assert 404, last_response.status
    assert 'application/json', last_response.header["Content-Type"]
    refute_empty data["message"]
  end

  def test_get_currency_base_html_not_found
    get '/DOG/to/ABC.html'
    assert !last_response.ok?
    assert 404, last_response.status
    assert 'text/html', last_response.header["Content-Type"]
    refute_nil last_response.body
  end

  def test_get_currency_base_txt_not_found
    get '/DOG/to/ABC.txt'
    assert !last_response.ok?
    assert 404, last_response.status
    assert 'text/plain', last_response.header["Content-Type"]
    refute_empty last_response.body
  end


  # Test post /api/v1/exchange endpoint
  def test_exchange_post_endpoint_success
    json_object='{ "currency": { "amount": "160", "base": "USD", "to": "COP" } }'
    post '/api/v1/exchange', json_object
    data = JSON.parse(last_response.body)
    message = data["message"]
    assert 200,last_response.status
    assert_equal message, data["message"]
  end

  def test_exchange_post_endpoint_bad_request
    json_object='{ "cur": { "amount": "160", "base": "USD", "to": "COP" } }'
    post '/api/v1/exchange', json_object
    data = JSON.parse(last_response.body)
    assert 400,last_response.status
    assert_equal "Invalid JSON", data["message"]
  end

  def test_exchange_post_endpoint_unprocessable_entity
    json_object='{ "currency": { "amount": "160", "base": "", "to": "COP" } }'
    post '/api/v1/exchange', json_object
    data = JSON.parse(last_response.body)
    assert 422,last_response.status
    assert_equal "can't be blank", data["message"][0]
  end

  def test_exchange_post_endpoint_not_found
    json_object='{ "currency": { "amount": "160", "base": "ABC", "to": "ACD" } }'
    post '/api/v1/exchange', json_object
    data = JSON.parse(last_response.body)
    assert 404,last_response.status
    assert_equal "not found currency code: ACD and base code: ABC", data["message"]
  end


end
