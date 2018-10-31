class FrmrSpeciality <  FrmrConnection
  FrmrSpeciality.table_name = 'frmr_specialities'
  has_many :frmr_doctors
  # default_scope {order(:name)}

  def self.search params
    list = FrmrSpeciality.all
    list = list.order(:code) if params[:sort_by_code].present?
    list = list.order(:name) if params[:sort_by_name].present?
    list = list.order(:code) if params[:sort_by_name].blank? && params[:sort_by_code].blank?
    list = list.where(high: true) if params[:type].to_i==1
    list = list.where(sec: true) if params[:type].to_i==2
    list = list.where('lower(code) like lower(?)', "#{params[:code]}%") if params[:code].present?
    list = list.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
    list = list
  end

end
