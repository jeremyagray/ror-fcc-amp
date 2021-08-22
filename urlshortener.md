# URL Shortener Microservice Project

A word of warning before starting:  don't leave this project live on the internet.  Scammers love disguising malicious URLs with shorteners, and this one has no security against such abuse.

Since this project requires saving data for later use, we finally need database access.  For demo projects, it's perfectly fine to use the default, file-based sqlite3 database that's already included.  To use the database, we'll need to generate a model and run a migration in addition to our normal routes and controller generation.

## Specifications

* You can `POST /api/shorturl` with a URL and get a JSON response of `{ original_url: 'http://www.original.com/', short_url: '1' }`.
* You can `GET /api/shorturl/:short_url` and redirect to the original URL.
* Invalid URLs get the response `{ 'error': 'invalid url' }`.

So, like the time server, we need two routes, one with a parameter.  We also need to do some processing to validate the URL.  The project hint suggests using NodeJS's `dns` module in addition to format checking, so we'll do that with some Ruby equivalents.

## Model

The model is fairly obvious.  We need a string to hold a URL and an ID number, which Rails provides by default.  Referring to the Rails Getting Started Guide again, we can generate a model with:
```
rails generate model Url url:string
```
which outputs
```
      invoke  active_record
      create    db/migrate/20210801011325_create_urls.rb
      create    app/models/url.rb
      invoke    test_unit
      create      test/models/url_test.rb
      create      test/fixtures/urls.yml
```
which gives us the data migration, a model, an empty test, and some test fixture data.  Feel free to explore these files, but they require no further work from us, other than running the data migration to create the tables in the database:
```
rails db:migrate
```
which should tell you that it's created the apprpriate URL table.

## Routes

The routes should be self-explanatory now:
```
  # URL Shortener.
  get '/api/shorturl/:short_url', to: 'url_shortener#get'
  post '/api/shorturl', to: 'url_shortener#new'
```
except now we have a `POST` route now and we have two controller methods.

## Controller

Let's implement the `new` method first, since we can't `GET` without having data to get.  Generate the controller:

```
rails generate controller UrlShortenter --skip-routes
```
which produces the controller and test files we'll use shortly.  Let's add a very naive `new` method:
```
  def new
    url = Url.new({ url: params[:url] })
    url.save
    render json: { 'original_url': url.url, 'short_url': url.id }
  end
```
which just takes the URL input, without processing or validation, saves it, and returns the appropriate JSON.  Wildly unsafe, but enough to run tests against.  So run the FreeCodeCamp tests against the wildly unsafe API, and everything fails (except have your own project) with CORS errors in the browser console and strange new HTTP 422 responses in the server console.  We know it's not CORS because we fixed that, so what is it?

Examining the errors, at the top of the backtrace, is a slightly helpful tidbit:
```
HTTP Origin header (https://www.freecodecamp.org) didn't match request.base_url (https://ror-fcc-amp.yourname.repl.co)
Completed 422 Unprocessable Entity in 1ms (Allocations: 458)
  
ActionController::InvalidAuthenticityToken (ActionController::InvalidAuthenticityToken):
```
that basically says it won't process our `POST` request since the hostnames of the request and API don't match, followed with some Ruby complaint about `InvalidAuthenticityToken`.  This looks a lot like some CSRF protection that a typical website needs that would be handled elsewhere for an API.  A little research points to some of the [Rails documentation](https://railsdoc.github.io/classes/ActionController/RequestForgeryProtection.html) with both an explanation and a solution.  It is CSRF protection that is enabled by default (yay!) when using the `ActionController::Base` like we are.  This behavior can be disabled by modifying `app/controllers/application_controller.rb`:
```
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
end
```
And again, wildly dangerous.  This is fine for intermittent demo or toy use, but in production you have to have some way of securing access to your API.  Rerun the FreeCodeCamp tests, and now the first two tests pass, the CORS errors have vanished, and the 422's are gone.  Since we have a partial solution, let's create the Rails tests to test it and keep it working:
```
  test 'should return shortened URL' do
    post '/api/shorturl', params: { url: 'http://www.cnn.com/' }
    assert_response :success
    data = @response.parsed_body
    assert data.key?('original_url')
    assert data.key?('short_url')
    assert_equal data['original_url'], 'http://www.cnn.com/'
    assert data['short_url']
  end
```
Let's also get the [FreeCodeCamp test inputs](https://github.com/freeCodeCamp/freeCodeCamp/blob/main/curriculum/challenges/english/05-apis-and-microservices/apis-and-microservices-projects/url-shortener-microservice.md) and write tests for them as well.

* `POST https://yourprojecturl/v=${Date.now()}` expecting success
* `GET /api/shorturl/:short_url` with the output of the first test, expecting success
* `POST ftp:/john-doe.org` expecting the invalid URL error

Let's use these as starts for the other two tests:
```
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
```
Running the tests results in expected failures since we don't yet have a `get` method in our controller.  Let's add one:
```
  def get
    if params[:short_url]
      url = Url.find(params[:short_url])
      redirect_to url.url
    end
  end
```
This finishes the `get` method and test.  All that's left is the invalid URL handling.  The tests will try `ftp:/john-doe.org` as an invalid URL.  It's easy to flag since it has only one slash.  The URL validation is the biggest source of problems in the FreeCodeCamp forum.  If you do advanced validation, remember that at a minimum, the URL has a protocol (`http`, `https`, or even `ftp`), the protocol separator (`://`), the hostname (`www.example.net` or similar), and an optional parameter string (`/api/shorturl/5` or variations with route parameters and query strings).  If you hand off anything other than the hostname to NodeJS's `dns.lookup()`, it barfs, as any number of forum posts will attest.

Let's add some simple validation to the `post` method that checks for one of the three protocols above and the correct separator:
```
  def new
    if params[:url].match(/^(https?|ftp):\/\//)
      url = Url.new({ url: params[:url] })
      url.save
      render json: { 'original_url': url.url, 'short_url': url.id }
    else
      render json: { 'error': 'invalid url' }
    end
  end
```
A little research into URL validation will show that this just scratches the surface, but it's enough to pass both sets of tests.  If you feel compelled to do more, read [this](https://fsharpforfunandprofit.com/posts/property-based-testing/) first.

## Looking Forward

Now that we can store and retrieve data, we can do anything.  Conceptually, we have basically everything we need to create any website we want, with Rails or Express.  There's a lot of plumbing left to understand (authentication, validation, processing, etc.), but the basics are done.  The next bit of plumbing to tackle is related models, which we'll tackle in the exercise tracker project.  But for now, our tests are all green so we commit, push, and [carry on](exercisetracker.md).
