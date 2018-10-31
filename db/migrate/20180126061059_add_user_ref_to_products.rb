class AddUserRefToProducts < ActiveRecord::Migration[5.0]
  def change
    rename_column :notify_messages, :user_id, :reception_user_id
    rename_column :notify_messages, :created_user_id, :user_id
    # add_reference :notify_messages, :user, foreign_key: true


  end
end
