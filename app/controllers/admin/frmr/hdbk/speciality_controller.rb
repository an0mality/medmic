class Admin::Frmr::Hdbk::SpecialityController < Admin:: ApplicationController
  before_action :check_frmr_admin
  load_and_authorize_resource :frmr_speciality
  layout 'frmr'


  def index
    @list = FrmrSpeciality.search(params).paginate(page: params[:page], per_page:10)
  end

  def search
    @list = FrmrSpeciality.search(params).paginate(page: params[:page], per_page:10)
    # @list = @list.order(:code) if params[:sort_by_code].present?
    # @list = @list.order(:name) if params[:sort_by_name].present?
  #   @list = @list.where('lower(code) like lower(?)', "#{params[:code]}%") if params[:code].present?
  #   @list = @list.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
  #   @list = @list.where(high: true) if params[:type].to_i==1
  #   @list = @list.where(sec: true) if params[:type].to_i==2
  end

  def download
    FrmrReport.speciality_list params
    if File.exist?("#{Rails.root}/public/frmr/speciality_list.xls")
      send_file(
          "#{Rails.root}/public/frmr/speciality_list.xls",
          filename: "speciality_list.xls",
          type: "application/xls")
    else
      redirect_to admin_frmr_hdbk_speciality_index_path, notice: "Сформируйте файл для скачивания"
    end
  end

end
