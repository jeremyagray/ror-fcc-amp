Rails.application.routes.draw do
  # Hello endpoint.
  get '/api/hello', to: 'hello#hello'

  # Header Parser.
  get 'api/whoami/', to: 'header_parser#whoami'

  # Time server endpoint.
  get '/api/', to: 'time#time'
  get '/api/:date', to: 'time#time'
end
