class FrmrPosition < FrmrConnection
  FrmrPosition.table_name='frmr_positions'
  has_many :frmr_doctors

  scope :doctor, ->{where(doctor: true).pluck(:id)}
  scope :paramedic, ->{where(paramedic: true).pluck(:id)}

  def self.search params
    list = FrmrPosition.all
    list = list.order(:code) if params[:sort_by_code].present?
    list = list.order(:name) if params[:sort_by_name].present?
    list = list.order(:code) if params[:sort_by_name].blank? && params[:sort_by_code].blank?
    list = list.where(doctor: true) if params[:dlo].to_i==1
    list = list.where(paramedic: true) if params[:dlo].to_i==2
    list = list.where('lower(code) like lower(?)', "#{params[:code]}%") if params[:code].present?
    list = list.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
    list = list

  end

end
