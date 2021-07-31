class HelloController < ApplicationController
  def hello
    if params[:name]
      render json: { 'greeting': "hello, #{params[:name]}" }
    else
      render json: { 'greeting': 'hello' }
    end
  end
end
