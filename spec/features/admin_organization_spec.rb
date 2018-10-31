require "rails_helper"

RSpec.feature "Organization", :type => :feature do

  let(:admin) {User.create!(email: "stas@miac.kaluga.ru", password: "12345678", username: 'bullet', fio: 'bullet',
                            confirmed_at: Time.now,consent_to_the_processing_of_personal_data: true, admin: true, organization_id: 112)}


  scenario "Переход по ссылке добавить организацию" do
    login_as admin
    visit "/admin/organizations"
    expect(page).to have_http_status(200)

    click_on "Добавить организацию"

    expect(page).to have_http_status(:success)
  end

  scenario "Поиск организации" do
    login_as admin
    visit "/admin/organizations"
    expect(page).to have_http_status(200)

    fill_in 'name', with: 'миац'

    click_button 'Поиск'

    expect(page.body).to match('Вишнев')
  end

  scenario "Редирект к списку" do
    login_as admin
    visit "/admin/organizations/new"
    expect(page).to have_http_status(200)

    click_on 'Вернуться к списку'

    expect(page).to have_http_status(200)
  end

  scenario 'создание' do
    login_as admin
    visit "/admin/organizations"

    click_on "Добавить организацию"

    expect(page.body).to match("Новая организация")

    
    fill_in 'organization[name]', with: 'Test'
    fill_in 'organization[address]', with: 'Testфыв фы'
    fill_in 'organization[city_id]', with: '1'
    fill_in 'organization[at_vpch]', with: true
    click_button 'Добавить организацию'

    expect(page.body).to match("Поиск организации")

  end

end
