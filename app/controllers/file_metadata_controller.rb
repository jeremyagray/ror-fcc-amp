require 'mimemagic'

class FileMetadataController < ApplicationController
  def index
  end

  def info
    name = params[:upfile].original_filename
    type = MimeMagic.by_magic(File.open(params[:upfile])).type
    size = params[:upfile].size
    render json: { "name": name, "type": type, "size": size }
  end
end
