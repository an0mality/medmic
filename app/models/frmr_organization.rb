class FrmrOrganization < FrmrConnection
  self.table_name='frmr_orgs'
  has_many :frmr_doctors
  has_many :users
  has_one :organization

  scope :work, ->{where('old is not true').order(:name)}
  scope :dlo, ->{where('dlo is true').order(:name)}

  def self.search params
    list = FrmrOrganization.all
    list = list.where('inn like ?',"%#{params[:inn]}%") if params[:inn].present?
    list = list.where('ogrn like ?', "%#{params[:ogrn]}%") if params[:ogrn].present?
    list = list.where(dlo: true) if params[:dlo].to_i==1
    list = list.where('dlo is not true') if params[:dlo].to_i==2
    list = list.where('old is not true') if params[:old].to_i==1
    list = list.where(old: true) if params[:old].to_i==2
    list = list.where('lower(name) like lower(?) or lower(full_name) like lower(?)', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
    list
  end

end
