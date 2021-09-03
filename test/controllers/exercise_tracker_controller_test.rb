require "test_helper"

class ExerciseTrackerControllerTest < ActionDispatch::IntegrationTest
  test 'should create a user' do
    post '/api/users', params: { username: 'bob'}
    data = @response.parsed_body
    assert data.key?('username')
    assert data.key?('_id')
    assert_equal data['username'], 'bob'
  end

  test 'should list users' do
    post '/api/users', params: { username: 'bob'}
    post '/api/users', params: { username: 'larry'}
    get '/api/users'
    users = @response.parsed_body
    # puts json: users
    assert_equal 2, users.length
    assert_equal 'bob', users[0]['username']
    assert_equal 'larry', users[1]['username']
  end

  test 'should create an exercise record' do
    post '/api/users', params: { username: 'bob'}
    user = @response.parsed_body

    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-01' }
    data = @response.parsed_body

    assert data.key?('username')
    assert data.key?('_id')
    assert data.key?('description')
    assert data.key?('duration')
    assert data.key?('date')
    assert_equal 'bob', data['username']
    assert_equal user['_id'], data['_id']
    assert_equal 'test', data['description']
    assert_equal 60, data['duration']
    assert_equal 'Mon Jan 01 1990', data['date']
    assert data['date'].is_a?(String)
  end

  test 'should return an exercise log' do
    post '/api/users', params: { username: 'bob'}
    user = @response.parsed_body

    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-01' }
    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-02' }
    get "/api/users/#{user['_id']}/logs"
    log = @response.parsed_body

    assert log.key?('username')
    assert_equal 'bob', log['username']
    assert log.key?('_id')
    assert_equal user['_id'], log['_id']
    assert log.key?('count')
    assert_equal 2, log['count']
    assert log.key?('log')
    assert log['log'].length >= 0

    log['log'].each do |ex|
      assert_equal 'test', ex['description']
      assert_equal 60, ex['duration']
    end

    assert_equal 'Mon Jan 01 1990', log['log'][0]['date']
    assert log['log'][0]['date'].is_a?(String)
    assert_equal 'Tue Jan 02 1990', log['log'][1]['date']
    assert log['log'][1]['date'].is_a?(String)
  end

  test 'should return a filtered exercise log' do
    post '/api/users', params: { username: 'bob'}
    user = @response.parsed_body

    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-01' }
    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-02' }
    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1989-12-28' }
    post "/api/users/#{user['_id']}/exercises", params: { description: 'test', duration: '60', date: '1990-01-04' }
    get "/api/users/#{user['_id']}/logs?from=1989-12-31&to=1990-01-03"
    log = @response.parsed_body

    assert log.key?('username')
    assert_equal 'bob', log['username']
    assert log.key?('_id')
    assert_equal user['_id'], log['_id']
    assert log.key?('count')
    assert_equal 2, log['count']
    assert log.key?('log')
    assert_equal 2, log['log'].length

    get "/api/users/#{user['_id']}/logs?from=1989-12-31&to=1990-01-03&limit=1"
    log = @response.parsed_body

    assert log.key?('username')
    assert_equal 'bob', log['username']
    assert log.key?('_id')
    assert_equal user['_id'], log['_id']
    assert log.key?('count')
    assert_equal 1, log['count']
    assert log.key?('log')
    assert_equal 1, log['log'].length

    get "/api/users/#{user['_id']}/logs?limit=3"
    log = @response.parsed_body

    assert log.key?('username')
    assert_equal 'bob', log['username']
    assert log.key?('_id')
    assert_equal user['_id'], log['_id']
    assert log.key?('count')
    assert_equal 3, log['count']
    assert log.key?('log')
    assert_equal 3, log['log'].length
  end
end
