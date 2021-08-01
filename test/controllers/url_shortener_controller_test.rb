require "test_helper"

class UrlShortenerControllerTest < ActionDispatch::IntegrationTest
  test 'should return shortened URL' do
    post '/api/shorturl', params: { url: 'http://www.cnn.com/' }
    assert_response :success
    data = @response.parsed_body
    assert data.key?('original_url')
    assert data.key?('short_url')
    assert_equal data['original_url'], 'http://www.cnn.com/'
    assert data['short_url']
  end

  test 'should redirect to shortened URL' do
    post '/api/shorturl', params: { url: 'http://www.cnn.com/' }
    assert_response :success
    data = @response.parsed_body
    get "/api/shorturl/#{data['short_url']}"
    assert_response :redirect
    assert_redirected_to data['original_url']
  end

  test 'should return error' do
    post '/api/shorturl', params: { url: 'ftp:/john-doe.org' }
    assert_response :success
    data = @response.parsed_body
    assert data.key?('error')
    assert_equal data['error'], 'invalid url'
  end
end
