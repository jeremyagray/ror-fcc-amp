Rails.application.routes.draw do
  # Hello endpoint.
  get '/api/hello', to: 'hello#hello'

  # Header Parser.
  get 'api/whoami/', to: 'header_parser#whoami'

  # URL Shortener.
  get '/api/shorturl/:short_url', to: 'url_shortener#get'
  post '/api/shorturl', to: 'url_shortener#new'

  # Time server endpoint.
  get '/api/', to: 'time#time'
  get '/api/:date', to: 'time#time'
end
