class Doctor < ApplicationRecord
  belongs_to :sector
  has_many :users
  belongs_to :organization

  validates :lsd_id,presence: {message: "Необходимо задать врача"}
  validates :organization_id,presence: {message: "Необходимо задать организацию"}
  scope :active, ->{where('active is true')}

  def status_active
    Doctor.find(id).active
  end
 
end
