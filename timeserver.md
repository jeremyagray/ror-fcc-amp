# Time Server Microservice Project

This API responds to GET requests with a JSON object containing the number of milliseconds since the epoch (unix time) and a UTC time string:

```
{
  "unix": 1627703332000,
  "utc": "Sat, 31 Jul 2021 03:48:52 GMT"
}
```

This data is easily produced with the Date methods `getTime()` and `toUTCString()`, respectively.  The project specifications say

1. `GET /api` returns a JSON object for now.
2. `GET /api/:date` should return JSON corresponding to `date`.  `date` should be parseable by `new Date(date)` in JavaScript.  Beware, because `Date()` can parse quite a lot of strings.
3. An invalid date will trigger an error response:

```
{
  "error": "Invalid Date"
}
```

The plan is simple.  Since this API doesn't have to store data, we don't need to worry with a database or models yet.  We just need to translate the JavaScript we have into some Ruby.  So, we need to implement two `GET` routes (with and without the date string parameter).  To do this, we'll have to create the routes and a controller to compute the correct output and figure out what the Ruby equivalents of the JavaScript `getTime()` and `toUTCString()`.  First, some background.

## Routes

The specifications call for a route almost identical to the hello route.  The time server should respond to a `GET /api` and return the JSON for now and to `GET /api/:date` for a string parseable by JavaScript's `Date()`.  So, let's add an analogous route to `config/routes.rb`:
```
  # Time server endpoint.
  get '/api/', to: 'time#time'
  get '/api/:date', to: 'time#time'
```
This points our route to the `time` method of the `time_controller` as with the hello API.  The only difference is that there is a route parameter (`req.params` from express) that we need to include.  This will pass to our controller in the `params` hash as with the hello API.  Rerun the test suite to make sure everything still works.

## Controller

We'll let Rails generate the controller and test files as before:
```
rails generate controller Time --skip-routes
```
which generates
```
      create  app/controllers/time_controller.rb
      invoke  erb
      create    app/views/time
      invoke  test_unit
      create    test/controllers/time_controller_test.rb
      invoke  helper
      create    app/helpers/time_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/time.scss
```
Let's edit the controller first and try to produce some JSON like the specification:
```
class TimeController < ApplicationController
  def time
    render json: { 'unix': 'milliseconds', 'utc': 'utcstring' }
  end
end
```
This will fail, but at least the format is correct.  It's time we started running the FreeCodeCamp tests against the project, so let's give it a try.  Ouch.  We failed everything except providing our own project, as expected.  If you look in the browser console, you should see errors like
```
Access to XMLHttpRequest at 'https://ror-fcc-amp.yournamehere.repl.co/api/2016-12-25' from origin 'https://www.freecodecamp.org' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```
which is the dreaded CORS error (fixed in express with the `cors` middleware).  We need to tell Rails it's okay for the strangers at `https://www.freecodecamp.com` to access our API (this is generally not safe; you only want your frontend to access your backend).  [A little searching](https://www.stackhawk.com/blog/rails-cors-guide/) will indicate the solution is to install `rack-cors` (`gem install rack-cors` or use the replit packages interface) and add some configuration in `config/initializers/cors.rb`:
```
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end
```
This is a bad idea in production as the `*` lets anyone, anywhere access your API which is probably not what you want except for projects like this.  Try the FreeCodeCamp tests again, and they still fail, but at least the console is not littered with CORS errors.  Time to fix the controller output now that the API is actually communicating with the outside world.

Let's handle the now part first.  Ruby has a `Time` class that works similarly to JavaScript's `Date()`, so let's use it.  Let's change the `time` method to:
```
    time = Time.now
    render json: { 'unix': time.to_i * 1000, 'utc': time.httpdate }
```
a little research on `Time` tells us that the `to_i` method converts the time to seconds, so multiplying by 1000 gives milliseconds.  A little more research turns up the `httpdate` method which is identical in output to the JavaScript `Date().toUTCString()`.  Rerun the tests, and now the last two that hit `/api` work.  Let's add some tests of our own to check the now route.  In `test/controllers/time_controller_test.rb`, we can add a test for now:
```
  test 'should return JSON for now' do
    get '/api'
    now = Time.now
    data = @response.parsed_body
    assert data.key?('unix')
    assert_in_delta data['unix'], now.to_i * 1000, 2000
    assert data.key?('utc')
    assert_equal data['utc'], now.httpdate
  end
```
The only new item here is the `assert_in_delta``, which asserts that the first number is within plus or minus the second, in this case, 2 seconds.  Run the tests and they should pass.

Now is as good time to write tests for the other part of the route with the parseable date string.  It's the source of many, many questions in the FreeCodeCamp forum because no one takes the time to get the [ground truth](https://github.com/freeCodeCamp/freeCodeCamp/blob/main/curriculum/challenges/english/05-apis-and-microservices/apis-and-microservices-projects/timestamp-microservice.md) that is being tested.  A quick perusal of the source yields the inputs tested:

* `2016-12-25`
* `1451001600000`
* `05 October 2011`
* `this-is-not-a-date`

October is the real killer.  Everyone assumes that the dates will be numbers.  The specification never says that.  Let's write some tests and then get that `date` route parameter passed in to the controller and see what happens.  The tests are just like the last one:

```
  test 'should return data for 2016-12-25' do
    get '/api', params: { date: '2016-12-25'}
    time = Time.parse('2016-12-25')
    data = @response.parsed_body
    data.key?('unix')
    assert_in_delta data['unix'], time.to_i * 1000, 2000
    assert data.key?('utc')
    assert_equal data['utc'], time.httpdate
  end

  test 'should return data for "1451001600000"' do
    get '/api', params: { date: '1451001600000'}
    time = Time.at(1451001600)
    data = @response.parsed_body
    data.key?('unix')
    assert_in_delta data['unix'], time.to_i * 1000, 2000
    assert data.key?('utc')
    assert_equal data['utc'], time.httpdate
  end

  test 'should return data for "05 October 2011"' do
    get '/api', params: { date: '05 October 2011'}
    time = Time.parse('05 October 2011')
    data = @response.parsed_body
    data.key?('unix')
    assert_in_delta data['unix'], time.to_i * 1000, 2000
    assert data.key?('utc')
    assert_equal data['utc'], time.httpdate
  end

  test 'should return data for "this-is-not-a-date"' do
    get '/api', params: { date: 'this-is-not-a-date'}
    data = @response.parsed_body
    data.key?('error')
    assert_equal data['error'], 'Invalid Date'
  end
```
Now pass in the route parameter just like in hello name:
```
  def time
    if params[:date]
      t = Time.parse(params[:date])
    else
      t = Time.now
    end
    render json: { 'unix': t.to_i * 1000, 'utc': t.httpdate }
  end
```
and rerun the tests to be rewarded with two failures, the `this-is-not-a-date` and the milliseconds test.  The FreeCodeCamp tests are in agreement if you run them with failures on tests 4 and 6.  Fixing the milliseconds should be easy.  We just need to detect when milliseconds are input (13 digits) and convert to seconds like `Time.parse()` wants.  Now the controller is
```
  def time
    if params[:date]
      if params[:date].match(/^\d+$/)
        t = Time.at(params[:date].to_i / 1000)
      else
        t = Time.parse(params[:date])
      end
    else
      t = Time.now
    end
    render json: { 'unix': t.to_i * 1000, 'utc': t.httpdate }
  end
```
This tries to match a string of only digits, and if it does, it assumes it is milliseconds and converts it to seconds and then time with `Time.at()`.  One error down on both tests.  Now, we just have to handle bad input.  Luckily, `Time.parse()` throws (raises) an `ArgumentError` on bad input that we can `rescue` (`catch`) and then return our error.  A final controller modification:
```
  def time
    if params[:date]
      if params[:date].match(/^\d+$/)
        t = Time.at(params[:date].to_i / 1000)
      else
        t = Time.parse(params[:date])
      end
    else
      t = Time.now
    end
    render json: { 'unix': t.to_i * 1000, 'utc': t.httpdate }
  rescue ArgumentError
    render json: { 'error': 'Invalid Date' }
  end
```
rerun both sets of tests, and the board is green.  Commit and push.

## Looking Forward

With the CORS problem solved and more tests under your belt, the remaining 4 projects are getting increasingly easier.  Go knock them out if you like while we slog forward.  While I don't think there is a good argument to be made that the Rails version is easier, faster, smaller, better, etc. than the JavaScript version (or vice versa), I am struck by how similar the route and behavior specifications are to the actual routes and controller in Rails.  And while my Rails project and JavaScript project are of essentially the same size and complexity, I spent much more time organizing the pieces of the JavaScript version that are just included in the Rails version.  Regardless, onward to [parsing headers](headerparser.md).
