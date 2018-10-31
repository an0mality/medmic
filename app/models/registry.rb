class Registry < VpchConnection
  Registry.table_name = "registries"
  
  has_many :analyses
  belongs_to :organization

  scope :new_reg, -> {where('spid_confirm_date is null and spid_sent_date is null and spid_sent_number is null')}

  def self.search params, current_user
    registry = Registry
    if current_user.spid
      if params[:act] == 'taken'
        Vpch.send_spid_registry
        registry = registry.where('spid_confirm_date is null and spid_sent_date is not null')
      elsif params[:act] == 'closed'
        registry = registry.where('spid_confirm_date is not null')
      else
        registry = registry.where(spid_confirm_date: nil, spid_sent_date: nil)
      end
    end
    if current_user.onko
      opened_registry = Analysis.no_error.where('cat_citology_id is null').pluck(:registry_id).uniq
      cloused_registry = Analysis.no_error.where('cat_citology_id is not null').pluck(:registry_id).uniq
      if params[:act] == 'closed'
        registry = registry.where(id: cloused_registry-opened_registry)
      else
        registry = registry.where(id: opened_registry)
      end
    end
    registry = registry.where('registry_key=?', params[:registry_key]) if params[:registry_key].present?
    registry = registry.where('organization_id=?', params[:registry_org]) if params[:registry_org].present?
    registry
  end

  def self.list current_user
   Registry.new_reg.where(organization_id: current_user.organization_id).last(3)
  end

end
