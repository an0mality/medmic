class Frmr::OutcomingDocumentsController < ApplicationController
  before_action :check_frmr
  load_and_authorize_resource :frmr_document

  def index
    @documents = FrmrDocument.where(organization_id: current_user.organization_id).paginate(page: params[:page], per_page:25).order(created_at: :desc)
  end

  def download
    @document = FrmrDocument.find(params[:id])
    send_data(@document.file_contents,
              type: @document.content_type,
              filename: @document.filename)
  end

  def upload
    if params[:attachments].present?
      params[:attachments].each do |file|
        filename = File.basename(file.original_filename)
        content_type = file.content_type
        file_contents = file.read
        doc = FrmrDocument.create(filename: filename, content_type: content_type, file_contents: file_contents, frmr_document_type_id: 1, organization_id: current_user.organization_id)
        if doc.present?
          ApplicationMailer.new_outcoming_document(doc).deliver
          redirect_to :back, notice: 'Документ загружен.'
        else
          render 'index', notice: 'Повторите загрузку, так как документ не был загружен.'
        end
      end
    end
  end

  def destroy
    @document = FrmrDocument.find(params[:id])
    if @document.is_done
      redirect_to frmr_outcoming_documents_path, notice: 'Файл уже обработан. Удаление невозможно'
    else
      @document.destroy
      redirect_to :back, notice: "#{@document.filename} удален"
    end
  end

end
