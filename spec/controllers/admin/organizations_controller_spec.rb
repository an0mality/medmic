require 'rails_helper'

RSpec.describe Admin::OrganizationsController, type: :controller do
  let(:user) {User.create!(email: "stas@miac.kaluga.ru", password: "12345678", username: 'bullet', fio: 'bullet',
                           confirmed_at: Time.now,consent_to_the_processing_of_personal_data: true, admin: false, organization_id: 112)}
  let(:admin) {User.create!(email: "stas@miac.kaluga.ru", password: "12345678", username: 'bullet', fio: 'bullet',
                            confirmed_at: Time.now,consent_to_the_processing_of_personal_data: true, admin: true, organization_id: 112)}


  it 'Доступ закрыт для обычного пользователя' do
    login_as user

    visit admin_organizations_path

    expect(page.body).to match('У вас нет доступа к этому разделу')
    # expect(response).to raise_error(CanCan::AccessDenied)

  end

  it 'Доступ открыт для админа' do
    login_as admin
    visit admin_organizations_path
    expect(response).to be_success
  end


end
