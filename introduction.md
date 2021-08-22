# Introduction to Ruby with the FreeCodeCamp API and Microservices Projects

[FreeCodeCamp's](https://www.freecodecamp.org/) MERN stack curriculum features five projects in the
[API and Microservices
section](https://www.freecodecamp.org/learn/apis-and-microservices/#apis-and-microservices-projects)
that introduce back end development with simple but increasingly
difficult tasks.  While you can do as much front end work as you like
with these projects, their specifications and tests only concern the
back end (except the last one), so the emphasis is on the [MongoDB](https://www.mongodb.com/),
[Express](https://expressjs.com/), and [NodeJS](https://nodejs.org/)
parts of the stack.

A fairly common question in the [FreeCodeCamp
forums](https://forum.freecodecamp.org/) concerns implementation of
these APIs in a framework, commonly
[Flask](https://flask.palletsprojects.com/) or
[Django](https://www.djangoproject.com/) (sorry [Ruby on
Rails](https://rubyonrails.org/).  Since the project tests are all
basic black box API tests, the framework should not matter as long as
the responses are correct.  So, let's do the projects with [Ruby on
Rails](https://rubyonrails.org/).  Even better, let's use the
[repl.it](https://replit.com/) [Ruby on
Rails](https://rubyonrails.org/) template so that we don't have to
host or deploy.

## Prerequisites

1. This is not an API tutorial.  You really should have already
completed the [API and Microservices projects](https://www.freecodecamp.org/learn/apis-and-microservices/#apis-and-microservices-projects) at [FreeCodeCamp](https://www.freecodecamp.org/) or have
that level of understanding of APIs, JSON, and the usual HTTP verbs.
1. This is not a [Ruby](https://www.ruby-lang.org/en/) tutorial.  Check out any number of other fine
[Ruby](https://www.ruby-lang.org/en/) resources on the web.  I like the [Ruby Koans](http://rubykoans.com/).  [Ruby](https://www.ruby-lang.org/en/) is friendly
enough that if you already know a language and can search the
internet, you should be fine.
1. This is not a [Ruby on Rails
tutorial](https://guides.rubyonrails.org/index.html).  Just go read
the [Ruby on Rails Guides](https://guides.rubyonrails.org/index.html)
that we'll be referencing repeatedly.  We'll be letting [Rails](https://rubyonrails.org/) do most
of the work anyway by leveraging [Ruby](https://www.ruby-lang.org/en/) and Rail's "convention over
configuration" philosophy.  But if you look at a [Rails](https://rubyonrails.org/) project
directory and squint, it looks like a [NodeJS](https://nodejs.org/)/[Express](https://expressjs.com/) project anyway.
1. You should be familiar with working on projects on
[repl.it](https://repl.it/) and with git.  Ideally you have a
[repl.it](https://repl.it/) account and a [Github](https://github.com/) account that you can
link so that you can push your project to [Github](https://github.com/) as you work.

## What We'll Learn

1. The main difference between this project and the [FreeCodeCamp](https://www.freecodecamp.org/) projects, beside the framework, is testing.  [FreeCodeCamp](https://www.freecodecamp.org/) does not introduce testing in its JavaScript projects until later, but we'll be using [Ruby](https://www.ruby-lang.org/en/)'s test facilities from the start.
1. We'll use the [Ruby on Rails Guides](https://guides.rubyonrails.org/index.html), especially the [Getting Started with Rails Guide](https://guides.rubyonrails.org/getting_started.html), as an example to implement these APIs.  So, you'll learn some [Ruby on Rails](https://rubyonrails.org/) as we go.
1. We'll also see some of the coding reduction that [Ruby on Rails](https://rubyonrails.org/) offers over [Express](https://expressjs.com/) and friends and [Django](https://www.djangoproject.com/).  We'll probably spend more time testing than coding, so welcome to the real world.

## Initial Configuration

Let's get to work and get the project configured so that in the next episode we can implement the first project, a time server.

1. Log on to [repl.it](https://repl.it/), creating an account if necessary, and create a new repl.  Near the end of the project type list, you'll find the [Rails](https://rubyonrails.org/) template.  Select that one.
1. Once it's loaded, look around and read the readme.  You'll note that we have to bind the app to 0.0.0.0, allow all hosts, and allow the app to be iframed.  Read the directions in the readme, but it seems these tasks are already completed.  The project still won't work completely yet, but it's a good start.
1. Pay special attention to the bit that says you need to prefix all [Rails](https://rubyonrails.org/) commands on [repl.it](https://repl.it/) with `bundle exec`.  So to run tests, for example, you would execute `bundle exec rails test`.
1. Go ahead and run the app.  You should see the normal welcome to [Rails](https://rubyonrails.org/) splash page.
1. Link your [Github](https://github.com/) account (make one if
necessary) to your [repl.it](https://repl.it/) account and commit and
push your work.

Note that we have some problems already.  The [FreeCodeCamp](https://www.freecodecamp.org/) tests won't work as yet, since we don't have a working [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) configuration.  Also, we're using Ruby 2.5, which hit end of life in April 2021.  Unless you're following along on [repl.it](https://repl.it/), run the latest version 3 of [Ruby](https://www.ruby-lang.org/en/) and update those gems.

Now that we have some semblance of a project, it's time to start implementing the [FreeCodeCamp](https://www.freecodecamp.org/) projects in earnest, beginning with the time server.  Bur first, let's say hello.

## Hello, World

"Hello, world", or it's descendant, "Hello, {name}" has to be the best
program ever written.  It does everything we ever want a program to
do:  take some input, do something, and produce some output.  Once you can write
"Hello, world" and "Hello, {name}", the rest is mere refinement.  For a web
API, we just need some route (`/api/hello` perhaps) that returns some
text, HTML, or JSON that says hello that we can access with a browser.
Let's build that.

Without getting into the weeds of MVC design, I'll assume you know or
can research any terminology you find unfamiliar.  The [Getting
Started with Rails
Guide](https://guides.rubyonrails.org/getting_started.html) is fairly
explicit in what needs to be done here.  We need a model to store
data, a route to accept requests, and a controller to handle the
requests.  We won't need to store data, so we'll talk models later.

### Routes

Let's add the route to `config/routes.rb`:
```
Rails.application.routes.draw do
  # Hello endpoint.
  get '/api/hello', to: 'hello#hello'
end
```
This will cause [Rails](https://rubyonrails.org/) to direct `GET` requests on `/api/hello` to the `hello` controller's `hello` method.  It will also pass any route parameters we care to use.

### Controller

[Rails](https://rubyonrails.org/) will generate code for our controller and route, but since the route is so simple, we did it ourselves.  Ask [Rails](https://rubyonrails.org/) to generate the hello controller by running (prefix all [Rails](https://rubyonrails.org/) commands with `bundle exec` on [repl.it](https://repl.it/)):
```
rails generate controller Hello --skip-routes
```
and you'll get several new files:
```
      create  app/controllers/hello_controller.rb
      invoke  erb
      create    app/views/hello
      invoke  test_unit
      create    test/controllers/hello_controller_test.rb
      invoke  helper
      create    app/helpers/hello_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/hello.scss
```
We're interested in the controller `app/controllers/hello_controller.rb` and its tests in `test/controllers/hello_controller_test.rb`.  Edit the first one and add the hello method from our route:
```
class HelloController < ApplicationController
  def hello
    render json: { 'greeting': 'hello' }
  end
end
```
`render` renders and returns our response and the `json:` should be self explanatory.  Time to run the project and hit the `/api/hello` endpoint to see what happens.  You should see the JSON from the hello controller we just created.

#### Tests

[Rails](https://rubyonrails.org/) (and [Ruby](https://www.ruby-lang.org/en/)) make it so easy to test, we have no excuse.  Let's create a test for our hello route and controller in `test/controllers/hello_controller_test.rb` from earlier.
```
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
end
```
These tests are almost always the same for every route and controller, so let's examine them individually.

First, hit the endpoint.
```
    # GET the API endpoint.
    get '/api/hello'
```
Second, assert it was successful.
```
    # Assert successful GET.
    assert_response :success
```
Third, parse the JSON returned.
```
    # Parse the JSON body.
    headers = @response.parsed_body
```
Fourth, assert that there is a `greeting` key in the hash.
```
    # Assert existence of a 'greeting' key.
    assert headers.key?('greeting')
```
Finally, assert that the value pointed to by `greeting` is actually `hello`.
```
    # Assert 'greeting' is 'hello.'
    assert_equal headers['greeting'], 'hello'
```
Even though we have no models or database access yet, run
```
rails db:migrate
```
to satisfy everyone and then run the test by running
```
rails test
```
from your shell.  It should pass.  Congratulations.

### Input from Route Parameters

[Rails](https://rubyonrails.org/) provides an easy way to get all your route parameter, query strings, etc., in the `params` hash passed to your controller.  Let's pass in a name and say hello to it.  Our route does not change and will pass on the name as long as we give the route the name in the correct place.  Since we have a `GET` route, let's pass the name as a query string in `name`, as in `GET /api/hello?name=jon`

This requires changes to the controller to look for the name:
```
class HelloController < ApplicationController
  def hello
    if params[:name]
      render json: { 'greeting': "hello, #{params[:name]}" }
    else
      render json: { 'greeting': 'hello' }
    end
  end
end
```
The `name` query string will appear in the `params` hash under the key `:name`.  Easy.  It's not like [Express](https://expressjs.com/) where I always confuse `req.body`, `req.params`, and `req.query`.  Always.  Mind the double quotes for string interpolation.  If `name` is not passed, we should still get the original response (rerun tests to verify).  Let's test parameter use as well by adding another test:
```
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
```
Note how the parameters are passed similarly to how they are processed.  This test should also pass.

## Looking Forward

Technically, you're done.  If you did the projects using [Express](https://expressjs.com/), at this point it's fairly trivial to knock them out in [Ruby](https://www.ruby-lang.org/en/) with the hello pattern, with tests to boot.  We still have to handle the aforementioned [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) problem without
```
app.use(cors({
  origin: '*',
  optionSuccessStatus: 200
}));
```
or we won't pass any [FreeCodeCamp](https://www.freecodecamp.org/) tests and we still have to wire in models, migrations, and a database to replace `mongoose`.  So run ahead and do it yourself or tag along and see the details as we start on the time server.  Just commit and push your code before you go [too far](timeserver.md).
