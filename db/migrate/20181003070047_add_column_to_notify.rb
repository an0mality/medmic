class AddColumnToNotify < ActiveRecord::Migration[5.0]
  def change
    add_column :notify_messages, :rmis, :boolean
    add_column :notify_messages, :frmr, :boolean
  end
end
