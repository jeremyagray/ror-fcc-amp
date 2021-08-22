# Header Parser Microservice Project

This really should have been the first project as it is essentially as easy as hello world once you know how to grab the header data.  The route specification is simply `GET /api/whoami` without parameters.  The expected JSON data is
```
{
  'ipaddress': 'from remote IP address',
  'language': 'from Accept-Language header',
  'software': 'from User-Agent header'
}
```
A little research will provide the Rails variables with the necessary information.

## Routes

Only one route:
```
  # Header Parser.
  get '/api/whoami', to: 'header_parser#whoami'
```
which will need a `header_parser` controller with a `whoami` method.

## Controller

Generate the controller as before:
```
rails generate controller HeaderParser --skip-routes
```
which creates the usual
```
      create  app/controllers/header_parser_controller.rb
      invoke  erb
      create    app/views/header_parser
      invoke  test_unit
      create    test/controllers/header_parser_controller_test.rb
      invoke  helper
      create    app/helpers/header_parser_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/header_parser.scss
```
Let's knock out the controller:
```
class HeaderParserController < ApplicationController
  def whoami
    render json: { 'ipaddress': request.remote_ip,
                   'language': request.headers['Accept-Language'],
                   'software': request.headers['User-Agent'] }
  end
end
```
a casual web search will provide you with the necessary information about `request`.  Tests are likewise trivial:
```
  test 'should tell me who I am' do
    get '/api/whoami'
    assert_response :success
    headers = @response.parsed_body
    headers.key?('ipaddress')
    headers.key?('language')
    headers.key?('software')
  end
```
Running the local and FreeCodeCamp tests should yield the same all-passing results, unless you have your routes in the wrong order which will cause the FreeCodeCamp tests to fail. Rails, like Express and Django, matches the first matching route.  So if you place `/api/whoami` after `/api/:date` the `date` route will match on `whoami` and it will hit your time server.

## Looking Forward

This was an easy one.  Next up is the oft discussed URL shortener, which finally requires data storage and some non-trivial input processing.  Commit, push, and [carry on](urlshortener.md).
