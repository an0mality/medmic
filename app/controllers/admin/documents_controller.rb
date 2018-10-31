class Admin::DocumentsController < Admin::ApplicationController
  load_and_authorize_resource :document
  def index
    @documents = Document.all.order(created_at: :asc)
    render layout: 'admin'
  end

  def create
    
    if params[:attachments].present?
      params[:attachments].each do |file|
        filename = File.basename(file.original_filename)
        content_type = file.content_type
        file_contents = file.read
        doc = Document.create(filename: filename, content_type: content_type, file_contents: file_contents)
      end
    end
    @documents = Document.all.order(created_at: :asc)
    respond_to do |f|
      f.html { redirect_to :back, layout: 'admin'}
      f.js
    end

  end

  def destroy
    @record = Document.destroy(params[:id])

    respond_to do |f|
      f.html { redirect_to :back, layout: 'admin'}
      f.js
    end

  end

  
end
