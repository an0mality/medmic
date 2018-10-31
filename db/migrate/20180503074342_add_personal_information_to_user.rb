class AddPersonalInformationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :consent_to_the_processing_of_personal_data, :boolean
  end
end
