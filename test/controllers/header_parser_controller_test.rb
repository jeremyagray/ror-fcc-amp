require "test_helper"

class HeaderParserControllerTest < ActionDispatch::IntegrationTest
  test 'should tell me who I am' do
    get '/api/whoami'
    assert_response :success
    headers = @response.parsed_body
    headers.key?('ipaddress')
    headers.key?('language')
    headers.key?('software')
  end
end
