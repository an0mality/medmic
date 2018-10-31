class AddFrmrOrganizationIdToOrganization < ActiveRecord::Migration[5.0]

  def change
    # remove_column :organizations, :frmr_organization_id
    add_column :organizations, :frmr_organization_id, :integer
  end

end
