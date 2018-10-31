class Organization < ApplicationRecord

	validate :check_connections_org

	scope :actual, ->{where(actual: true)}

	has_many :sectors
	has_many :users
	has_man  :analysis
	has_many :prgs, through: :mse_patients
	has_many :prg_rhbs, through: :mse_patients
	has_many :doctors
	has_many :registries
	belongs_to :frmr_organization
	belongs_to :rhb_exc
	belongs_to :ahd_type
	has_many :frmr_documents

	validates :address, presence:  {message: "Необходимо задать адрес"}
	validates :type_org_id, presence:  {message: "Необходимо задать тип организации"}
	validates :name, presence:  {message: "Необходимо задать краткое наименование организации"}
	# validates :city_code, presence:  {message: "Необходимо задать код города организации"}

	scope :at_vpch, -> {where(at_vpch: true).order('name, type_org_id')}

	def self.check_org params
		organization = Organization.find(params[:id])
		if organization.frmr_organization_id.present? || organization.rhb_exc_id.present?
		else
			organization.destroy
		end
	end

	def self.search params
		result = Organization
		result = result.where('lower(name) like lower(?) or lower(full_name) like lower(?)', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
		result = result.where(city_id: params[:city_id]) if params[:city_id].present?
		result = result.where(type_org_id: params[:type_org_id]) if params[:type_org_id].present?
		result = result.where(id: params[:organization_id]) if params[:organization_id].present?
		result = result.order(:name)
		result
	end

	def self.create_record params
		Organization.create(name: params[:name], full_name: params[:full_name], address: params[:address], tel_secretary: params[:tel_secretary], type_org_id: params[:type_org_id], city_id: params[:city_id],web_site: params[:web_site], rhb_exc_id: params[:rhb_exc_id], frmr_organization_id: params[:frmr_organization_id], at_vpch: params[:at_vpch], actual: params[:actual] )
	end

	def self.find_lsd_sector_org
		Organization.all.each do |org|
			MdClinicSeparation.find_by_sql("SELECT md_clinic_district.name,md_clinic_district.id
FROM md_clinic_separation JOIN md_clinic_district ON md_clinic_district.separation_id = md_clinic_separation.id
 WHERE (lower(md_clinic_separation.name) like '%пед%' or md_clinic_district.type_id = 2)
 AND md_clinic_separation.clinic_id = #{org.lsd_organization_id} AND md_clinic_district.to_dt is NULL").each do |f|
				sec = Sector.where("lower (name) like lower (?)","%#{f.name.strip}%")
				if sec.present?
					sec.update_attributes(:lsd_sector_id, f.id)
				else
					Sector.create(lsd_sector_id: f.id, name: f.name.strip, organization_id: org.id)
				end
			end
		end
	end

	def self.update_sector_lsd_for_one_org params
		org=Organization.find(params[:id])
		MdClinicSeparation.find_by_sql("SELECT md_clinic_district.name, md_clinic_district.id
FROM md_clinic_separation JOIN md_clinic_district ON md_clinic_district.separation_id = md_clinic_separation.id
WHERE (lower(md_clinic_separation.name) like '%пед%' or md_clinic_district.type_id = 2)
AND md_clinic_separation.clinic_id = #{org.lsd_organization_id} AND md_clinic_district.to_dt is NULL ").each do |f|
			sec = Sector.where("lower (name) like lower (?)","%#{f.name.strip}%").where(organization_id: params[:id])
			if sec.present?
				sec.first.update_attribute(:lsd_sector_id, f.id)
			end
		end
	end

	def self.create_sector_lsd_for_one_org params
		org=Organization.find(params[:id])
		MdClinicSeparation.find_by_sql("SELECT md_clinic_district.name, md_clinic_district.id
FROM md_clinic_separation JOIN md_clinic_district ON md_clinic_district.separation_id = md_clinic_separation.id
WHERE (lower(md_clinic_separation.name) like '%пед%' or md_clinic_district.type_id = 2)
AND md_clinic_separation.clinic_id = #{org.lsd_organization_id} AND md_clinic_district.to_dt is NULL ").each do |f|
			sec = Sector.where("lower (name) like lower (?)","%#{f.name.strip}%").where(organization_id: params[:id])
			unless sec.present?
				Sector.create(lsd_sector_id: f.id, name: f.name.strip, organization_id: org.id)
			end
		end
	end
	
private
	def check_connections_org
		if self.frmr_organization_id.present? || self.rhb_exc_id.present?
			errors.add(:base,"Невозможно удалить организацию, которая связана с другими таблицами")
		end
	end


end
