require "test_helper"

class HelloControllerTest < ActionDispatch::IntegrationTest
  test 'should say hello' do
    # GET the API endpoint.
    get '/api/hello'
    # Assert successful GET.
    assert_response :success
    # Parse the JSON body.
    headers = @response.parsed_body
    # Assert existence of a 'greeting' key.
    assert headers.key?('greeting')
    # Assert 'greeting' is 'hello.'
    assert_equal headers['greeting'], 'hello'
  end

  test 'should say hello to a person' do
    # GET the API endpoint.
    get '/api/hello', params: { name: 'jon' }
    # Assert successful GET.
    assert_response :success
    # Parse the JSON body.
    headers = @response.parsed_body
    # Assert existence of a 'greeting' key.
    assert headers.key?('greeting')
    # Assert 'greeting' is 'hello.'
    assert_equal headers['greeting'], 'hello, jon'
  end
end
