class RemoveFieldtoNotifyMessage < ActiveRecord::Migration[5.0]
  def change
    remove_column :notify_messages, :role_id
    remove_column :notify_messages, :email
    remove_column :notify_messages, :phone
  end
end
