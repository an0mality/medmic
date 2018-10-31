class DocumentsController < ApplicationController
  
  def index
    @documents = Document.all.order(created_at: :asc)
  end

  def show
  @document = Document.find(params[:id])
  send_data(@document.file_contents,
            type: @document.content_type,
            filename: @document.filename)

  end


end
