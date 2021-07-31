require "test_helper"

class TimeControllerTest < ActionDispatch::IntegrationTest
  test 'should return JSON for now' do
    get '/api'
    now = Time.now
    data = @response.parsed_body
    assert data.key?('unix')
    assert_in_delta data['unix'], now.to_i * 1000, 2000
    assert data.key?('utc')
    assert_equal data['utc'], now.httpdate
  end

  test 'should return headers for 2016-12-25' do
    get '/api', params: { date: '2016-12-25'}
    time = Time.parse('2016-12-25')
    headers = @response.parsed_body
    headers.key?('unix')
    assert_in_delta headers['unix'], time.to_i * 1000, 2000
    assert headers.key?('utc')
    assert_equal headers['utc'], time.httpdate
  end

  test 'should return headers for "1451001600000"' do
    get '/api', params: { date: '1451001600000'}
    time = Time.at(1451001600)
    headers = @response.parsed_body
    headers.key?('unix')
    assert_in_delta headers['unix'], time.to_i * 1000, 2000
    assert headers.key?('utc')
    assert_equal headers['utc'], time.httpdate
  end

  test 'should return headers for "05 October 2011"' do
    get '/api', params: { date: '05 October 2011'}
    time = Time.parse('05 October 2011')
    headers = @response.parsed_body
    headers.key?('unix')
    assert_in_delta headers['unix'], time.to_i * 1000, 2000
    assert headers.key?('utc')
    assert_equal headers['utc'], time.httpdate
  end

  test 'should return headers for "this-is-not-a-date"' do
    get '/api', params: { date: 'this-is-not-a-date'}
    headers = @response.parsed_body
    headers.key?('error')
    assert_equal headers['error'], 'Invalid Date'
  end
end
