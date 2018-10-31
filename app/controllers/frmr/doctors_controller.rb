class Frmr::DoctorsController < ApplicationController
  before_action :check_frmr
  load_and_authorize_resource :frmr_doctor

  layout 'frmr'

  def index
    # @doctors = FrmrDoctor.where(frmr_organization_id: current_user.organization.frmr_organization_id).order(updated_at: :desc).paginate(page: params[:page], per_page:10)
    @doctors = FrmrDoctor.search(current_user, params).paginate(page: params[:page], per_page:10)
  end

  def search_surname
    @result = FrmrDoctor.where('frmr_organization_id = ? and lower(surname) like lower(?)',current_user.organization.frmr_organization_id, "%#{params[:term].strip}%" ).order(:surname).pluck(:surname)
    render json: @result
  end

  def search_code
    @result = FrmrDoctor.where('frmr_organization_id = ? and lower(code) like lower(?)',current_user.organization.frmr_organization_id, "%#{params[:term].strip}%" ).order(:code).pluck(:code)
    render json: @result
  end

  def xls
    FrmrReport.doctors_list current_user
    if File.exist?("#{Rails.root}/public/frmr/doctors_list_#{current_user.organization.name}.xls")
      send_file(
          "#{Rails.root}/public/frmr/doctors_list_#{current_user.organization.name}.xls",
          filename: "Список медработников для #{current_user.organization.name}.xls",
          type: "application/xls")
    else
      redirect_to :back, notice: "Ошибка формирования файла, сообщите в техническую поддержку"
    end

  end

  def search
    @doctors = FrmrDoctor.search(current_user, params).paginate(page: params[:page], per_page:10)
  end

end
