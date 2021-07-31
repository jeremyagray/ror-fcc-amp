Rails.application.routes.draw do
  # Hello endpoint.
  get '/api/hello', to: 'hello#hello'
end
