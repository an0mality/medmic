class Sector < ApplicationRecord
  default_scope {order(:name)}


  belongs_to :organization
  has_many :doctor
  belongs_to :sector_type

  validates :organization_id,presence: {message: "Необходимо задать организацию"}
  validates :name,presence: {message: "Необходимо задать название участка"}

  scope :actual, -> {where('old is not true').order(:name)}

  def self.sectors_feed current_user
    if current_user.admin
       return Sector.actual.all
    else
       return Sector.actual.where(organization_id: current_user.organization_id).order(:name)
    end
  end

  def rmis_name
    MdClinicDistrict.where(id: self.lsd_sector_id).present? ? MdClinicDistrict.find(self.lsd_sector_id).name : 'Участок не найден в РМИС'
  end



end
