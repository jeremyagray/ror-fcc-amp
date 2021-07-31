class TimeController < ApplicationController
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
end