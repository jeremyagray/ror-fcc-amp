Rails.application.routes.draw do
  # Hello endpoint.
  get '/api/hello', to: 'hello#hello'

  # Header Parser.
  get 'api/whoami/', to: 'header_parser#whoami'

  # URL Shortener.
  get '/api/shorturl/:short_url', to: 'url_shortener#get'
  post '/api/shorturl', to: 'url_shortener#new'

 # Exercise Tracker.
  post '/api/users', to: 'exercise_tracker#addUser'
  get '/api/users', to: 'exercise_tracker#getUsers'

  post '/api/users/:_id/exercises', to: 'exercise_tracker#addExercise'
  get '/api/users/:_id/logs', to: 'exercise_tracker#getLog'
  get '/api/users/:_id/logs?:limit', to: 'exercise_tracker#getLog'
  get '/api/users/:_id/logs?:from&:to', to: 'exercise_tracker#getLog'

  # Time server endpoint.
  get '/api/', to: 'time#time'
  get '/api/:date', to: 'time#time'
end
