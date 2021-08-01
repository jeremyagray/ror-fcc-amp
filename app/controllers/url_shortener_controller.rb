class UrlShortenerController < ApplicationController
  def new
    if params[:url].match(/^(https?|ftp):\/\//)
      url = Url.new({ url: params[:url] })
      url.save
      render json: { 'original_url': url.url, 'short_url': url.id }
    else
      render json: { 'error': 'invalid url' }
    end
  end

  def get
    if params[:short_url]
      url = Url.find(params[:short_url])
      redirect_to url.url
    end
  end
end
