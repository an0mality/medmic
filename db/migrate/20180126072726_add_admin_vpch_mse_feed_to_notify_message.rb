class AddAdminVpchMseFeedToNotifyMessage < ActiveRecord::Migration[5.0]
  def change
    rename_column :notify_messages, :reception_user_id, :recipient_user_id
    add_column :notify_messages, :admin , :boolean
    add_column :notify_messages, :feed , :boolean
    add_column :notify_messages, :vpch , :boolean
    add_column :notify_messages, :mse , :boolean
  end

end
