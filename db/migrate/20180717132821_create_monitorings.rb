class CreateMonitorings < ActiveRecord::Migration[5.0]
  def change
    create_table :monitorings do |t|
      t.integer :user_id
      t.string :path
      t.datetime :date

    end
  end
end
