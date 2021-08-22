# Exercise Tracker Microservice Project

It's finally time to connect two data models.  In the MERN stack, this
usually means coding two schemas in `mongoose` with a shared ID and
then providing all the code to access and maintain the connections.
The idea is the same everywhere, but with
[Rails](https://rubyonrails.org/), we just have to tell it the models
are connected and [Rails](https://rubyonrails.org/) will generate the
SQL necessary to do all the work.  All we have to do is manipulate the
records.

## [Specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker)

* `POST /api/users` with `username` to create a new user and return `{
  'username': username, '_id': id }`.
* `GET /api/users` to get an array of all users, formatted as above.
  `POST /api/users/:_id/exercises` with `description`, `duration`, and
  an optional `date`, defaulting to now, returning user object with the
  exercise fields added.
* `GET request to /api/users/:_id/logs` to retrieve a full exercise
  log of any user.  The returned response will be the user object with
  a `log` array of all the exercises added.  Each `log` item has the
  `description`, `duration`, and `date` properties.  This will include
  a `count` property representing the number of exercises returned.
* `GET /api/users/:_id/logs` also accepts `from` and `to` query
  strings as dates in `yyyy-mm-dd` format and `limit` as an integer of
  how many logs to send.

### Test Inputs

* `POST /api/users` with `{ 'username': <random string> }`
* `GET /api/users`
* `POST /api/users/:_id/exercises` after creating user, with `{
  'username': username, 'description': 'test', 'duration': '60',
  '_id': _id, 'date': 'Mon Jan 01 1990'}`
* `GET /api/users/:_id/logs` after creating a user and one exercise
  record.  This test is repeated for checking both the log and the
  count.
* `GET /api/users/:_id/logs` after creating a user and two exercise
  records, checking for both records in the `from` to `to` range and
  checking the length with a `limit = 1`.

Looking at the
[specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker),
this looks like a user model and controller, two user routes, two user
controller methods, one exercise model linked to the user model and a
controller, one exercise route, one exercise controller method, and at
least one log controller method.

## Models

The user model only needs a username and an auto-generated id.  Let
[Rails](https://rubyonrails.org/) generate the model:
```
rails generate model User username:string
```
Similarly with the exercise model:
```
rails generate model Exercise description:text duration:string date:date user:references
```
The `user:references` is the important bit as it establishes the
relationship between `User` and `Exercise`.  Don't forget to run the
migration to build the tables and schema.

## Routes

The routes should be straightforward.  They are very similar to the
URL shortener routes but there are more of them.  Let's start with
these:
```
 # Exercise Tracker.
  post '/api/users', to: 'exercise_tracker#addUser'
  get '/api/users', to: 'exercise_tracker#getUsers'

  post '/api/users/:_id/exercise', to: 'exercise_tracker#addExercise'
  get '/api/users/:_id/logs', to: 'exercise_tracker#getLog'
```
and change them later if necessary.  With these routes, we'll need an
`exercise_tracker` controller with `addUser`, `getUsers`,
`addExercise`, and `getLog` methods.

## Controllers

Let's generate the controller in the usual way and start adding methods.
```
rails generate controller ExerciseTracker --skip-routes
```
This generates the usual files.  Adding the `addUser` method should
get us to the point of running the [FreeCodeCamp
tests](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker)
against the project.
```
  def addUser
    user = User.new({ username: params[:username] })
    user.save
    render json: { 'username': user.username, '_id': user.id }
  end
```
That gets the first two tests passing and good, solid, 404 fails on
the rest since they are not implemented.  Let's create a test for
`addUser`:
```
  test 'should create a user' do
    post '/api/users', params: { username: 'bob'}
    data = @response.parsed_body
    assert data.key?('username')
    assert data.key?('_id')
    assert_equal data['username'], 'bob'
  end
```
Run the tests, and we are passing.  Let's add `getUsers` and its test:
```
  def getUsers
    users = []

    User.all.each do |user|
      users.append({ 'username': user.username, '_id': user.id })
      # puts `{ 'username': #{user.username}, '_id': #{user.id} }`
    end

    render json: users
  end
```
```
  test 'should return a user array' do
    post '/api/users', params: { username: 'bob'}
    post '/api/users', params: { username: 'marley'}
    get '/api/users'
    data = @response.parsed_body
    assert_equal data.length, 2

    data.each do |u|
      assert u.key?('username')
      assert u.key?('_id')
    end

    assert_equal data[0]['username'], 'bob'
    assert_equal data[1]['username'], 'marley'
  end
```
Everything looks great, so let's run the tests for a failure?
```
Failure:
ExerciseTrackerControllerTest#test_should_return_a_user_array [/home/runner/ror-fcc-amp/test/controllers/exercise_tracker_controller_test.rb:17]:
Expected: 4
  Actual: 2
```
What gives?  Four users?  We only created two in our test, but
[Rails](https://rubyonrails.org/) was being helpful.  It created two
users in the fixture data for the `User` model when we generated that.
So, comment out both fixture users in `tests/fixtures/users.yml` or
change the expected length.  Now, the
[Rails](https://rubyonrails.org/) tests pass, let's check the
[FreeCodeCamp
tests](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker),
and the `GET /api/users`...fails?  Why?  Let's add a `puts users` at
the end of `getUsers` or hit the API with a browser to inspect the
output, but everything looks fine.  The only thing left to check is
the [FreeCodeCamp
test](https://github.com/freeCodeCamp/freeCodeCamp/blob/main/curriculum/challenges/english/05-back-end-development-and-apis/back-end-development-and-apis-projects/exercise-tracker.md),
and its source says:
```
async (getUserInput) => {
  const url = getUserInput('url');
  const res = await fetch(url + '/api/users');
  if (res.ok) {
    const data = await res.json();
    assert.isArray(data);
    assert.isString(data[0].username);
    assert.isString(data[0]._id);
  } else {
    throw new Error(`${res.status} ${res.statusText}`);
  }
};
```
The most important bit is the `assert.isString(data[0]._id);`.  Oops,
we sent a number.  Let's rework the relevant bit of the controller:
```
      users.append({ 'username': user.username, '_id': "#{user.id}" })
```
and rerun both sets of tests and the ones that should pass, pass.

Moving on to the exercise records, let's implement the `addExercise`
controller method:
```
  def addExercise
    user = User.find(params[:_id])

    if params[:date]
      date = Date.parse(params[:date])
    else
      date = Date.today
    end

    ex = Exercise.new({ :user => user, :description => params[:description], :duration => params[:duration], :date => date })
    ex.save

    render json: { :username => user.username, :_id => user.id, :description => ex.description, :duration => ex.duration, :date => date.strftime("%a %b %d %Y") }
  end
```
which gets the correct user, handles the date, creates a new exercise,
and returns some JSON (with a formatted date).  Let's write a test
too:
```
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
    assert_equal '60', data['duration']
    assert_equal 'Mon Jan 01 1990', data['date']
  end
```
and then run the [Rails](https://rubyonrails.org/) tests, which pass
while the [FreeCodeCamp
test](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker)
for this route fails.  What now?  Well, if you closely examine the
expected object in the [FreeCodeCamp
test](https://github.com/freeCodeCamp/freeCodeCamp/blob/main/curriculum/challenges/english/05-back-end-development-and-apis/back-end-development-and-apis-projects/exercise-tracker.md)
```
    const expected = {
      username,
      description: 'test',
      duration: 60,
      _id,
      date: 'Mon Jan 01 1990'
    };
```
you'll notice that `duration` is an integer.  Easy to miss and easy to
fix.  First, make the [Rails](https://rubyonrails.org/) test fail if
it's not an integer.
```
    assert_equal 60, data['duration']
```
Rerun the [Rails](https://rubyonrails.org/) tests to make sure it
fails, then fix the controller:
```
    render json: { :username => user.username, :_id => user.id, :description => ex.description, :duration => ex.duration.to_i, :date => date.strftime("%a %b %d %Y") }
```
Notice the `to_i` method on `duration`, which converts it to an
integer.  Rerun the [Rails](https://rubyonrails.org/) tests to verify
passing, then rerun the [FreeCodeCamp
test](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker)
to verify those.

Now on to the log route.  One controller method should handle all the
log routes, but will have to act conditionally on the three
parameters.  First, let's get a test that looks good:
```
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
      assert_equal '60', ex['duration']
    end

    assert_equal 'Mon Jan 01 1990', log['log'][0]['date']
    assert_equal 'Tue Jan 02 1990', log['log'][1]['date']
  end
```
This test should cover the basic log.  Now, a controller method:
```
  def getLog
    user = User.find(params[:_id])

    log = { :username => user.username, :_id => user.id, :log => [] }

    user.exercises.each do |ex|
      log[:log] << { :description => ex.description, :duration => ex.duration, :date => ex.date.strftime("%a %b %d %Y") }
    end

    log[:count] = log[:log].length

    render json: log
  end
```
This is the basic version with no filtering or limit, but it should
have the correct format.  Run both tests, and everything passes except
the filter/limit test.  Let's create the filter and limit test using
the [FreeCodeCamp
test](https://github.com/freeCodeCamp/freeCodeCamp/blob/main/curriculum/challenges/english/05-back-end-development-and-apis/back-end-development-and-apis-projects/exercise-tracker.md)
as an example:
```
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
```
Then, run and fail it.  Implement the `getLog` controller method:
```
  def getLog
    user = User.find(params[:_id])

    log = { :username => user.username, :_id => user.id, :log => [] }

    user.exercises.each do |ex|
      if params[:from] and ex.date < Date.parse(params[:from])
        next
      end
      if params[:to] and ex.date > Date.parse(params[:to])
        next
      end
      log[:log] << { :description => ex.description, :duration => ex.duration, :date => ex.date.strftime("%a %b %d %Y") }
    end

    if params[:limit]
      log[:log] = log[:log][-params[:limit].to_i..(log[:log].length - 1)]
    end

    log[:count] = log[:log].length

    render json: log
  end
```
It's the same method as before, except with checks for the existence of the three parameters and their usage.  This implementation is more flexible than is required, but it passes both sets of tests.  Finally.

## Looking Forward

Again, we follow the same basic process and let
[Rails](https://rubyonrails.org/) do as much work as possible and just
turn
[specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/exercise-tracker)
into code in fairly straightforward ways.  The related models weren't
the challenge here, it was formatting the JSON to match expectations
and the common integer or string problem that happens quite
frequently.  And again, we've written less code than the
[NodeJS](https://nodejs.org/) or
[Django](https://www.djangoproject.com/) versions of this project and
[Rails](https://rubyonrails.org/) has generated more, but in the end,
the projects would all have similar levels of code, files, and
complexity regardless of implementation.  Next up is the file metadata
project, a much simpler project as long as we can figure out how to
compute the metadata.  With green tests finally, commit, push, and on
to the [last project](filemetadata.md).
