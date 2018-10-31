class Admin::Frmr::Hdbk::PositionController < Admin:: ApplicationController
  before_action :check_frmr_admin
  load_and_authorize_resource :frmr_position
  layout 'frmr'


  def index
    @list = FrmrPosition.search(params).paginate(page: params[:page], per_page:10)
    # @list = @list.order(:code) if params[:sort_by_code].present?
    # @list = @list.order(:name) if params[:sort_by_name].present?
    # @list = @list.order(:code) if params[:sort_by_name].blank? && params[:sort_by_code].blank?
    # @list = @list.where(doctor: true) if params[:dlo].to_i==1
    # @list = @list.where(paramedic: true) if params[:dlo].to_i==2
    # @list = @list.where('lower(code) like lower(?)', "#{params[:code]}%") if params[:code].present?
    # @list = @list.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
    # @list = @list.paginate(page: params[:page], per_page:10)

  end

  def search
    @list = FrmrPosition.search(params).paginate(page: params[:page], per_page:10)
  #   @list = @list.order(:code) if params[:sort_by_code].present?
  #   @list = @list.order(:name) if params[:sort_by_name].present?
  #   @list = @list.where('lower(code) like lower(?)', "#{params[:code]}%") if params[:code].present?
  #   @list = @list.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
  #   @list = @list.where(doctor: true) if params[:dlo].to_i==1
  #   @list = @list.where(paramedic: true) if params[:dlo].to_i==2
  #   @list = @list.paginate(page: params[:page], per_page:10)
  end

end
