class FrmrDoctor < FrmrConnection
  FrmrDoctor.table_name='frmr_doctors'
  belongs_to :frmr_position
  belongs_to :frmr_quality
  belongs_to :frmr_speciality
  belongs_to :frmr_organization
  belongs_to :frmr_fap

  validates :code, presence: true
  validates :surname, presence: true
  validates :name, presence: true
  validates :birth, presence: true

  validates :employment_date, presence: true
  validates :frmr_organization_id, presence: true

  scope :active, ->{where('dismissal_date is null and dlo_unreg is null')}

  def fio
    self.surname + ' '+self.name+ ' '+self.patr_name
  end

  def self.search current_user, params
    doctors = FrmrDoctor.where(frmr_organization_id: current_user.organization.frmr_organization_id).order(:surname)

    doctors = doctors.where('lower(surname) like lower(?)',"%#{params[:surname]}%").order(:surname) if params[:surname].present?
    doctors = doctors.where('code like (?)',"%#{params[:code]}%").order(:code) if params[:code].present?

    doctors
  end

  def position_code
    self.frmr_position.present? ? self.frmr_position.code : ''
  end
  def quality_code
    self.frmr_quality_id.present? ? self.frmr_quality.code : ''
  end
  def extra_position_code
    self.frmr_extra_position_id.present? ? FrmrPosition.find(self.frmr_extra_position_id).code : ''
  end

  def position_name
    self.frmr_position.present? ? self.frmr_position.name : ''
  end

  def extra_position_name
    self.frmr_extra_position_id.present? ? FrmrPosition.find(self.frmr_extra_position_id).name : ''
  end

  def dlo_reg_date
    self.dlo_reg.present? ? self.dlo_reg.strftime('%d.%m.%Y') : ''
  end

  def birth_date
    self.birth.present? ? self.birth.strftime('%d.%m.%Y') : ''
  end

  def dlo_unreg_date
    self.dlo_unreg.present? ? self.dlo_unreg.strftime('%d.%m.%Y') : ''
  end

  def speciality_code
    self.frmr_speciality.present? ? self.frmr_speciality.code : ''
  end

  def speciality_name
    self.frmr_speciality.present? ? self.frmr_speciality.name : ''
  end

  def fap_code
    self.frmr_fap.present? ? self.frmr_fap.code : ''
  end

  def fap_name
    self.frmr_fap.present? ? self.frmr_fap.name : ''
  end

  def quality_code
    self.frmr_quality.present? ? self.frmr_quality.code : ''
  end

  def quality_name
    self.frmr_quality.present? ? self.frmr_quality.name : ''
  end

  def employment
    self.employment_date.present? ? self.employment_date.strftime('%d.%m.%Y') : ''
  end

  def dismissal
    self.dismissal_date.present? ? self.dismissal_date.strftime('%d.%m.%Y') : ''
  end

  def cert
    self.cert_date.present? ? self.cert_date.strftime('%d.%m.%Y') : ''
  end

  def ogrn
    self.frmr_organization.present? ? self.frmr_organization.ogrn.strip : ' '
  end

end
