class Frmr::IncomingDocumentsController < ApplicationController
  before_action :check_frmr
  load_and_authorize_resource :frmr_document
  def index
    @documents = FrmrDocument.frmr_miac.where(organization_id: current_user.organization_id).paginate(page: params[:page], per_page:5).order(created_at: :desc)
  end

  def download
    @document = FrmrDocument.find(params[:id])
    send_data(@document.file_contents,
              type: @document.content_type,
              filename: @document.filename)
  end

end
