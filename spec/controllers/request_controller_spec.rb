require 'rails_helper'


RSpec.describe RequestController, type: :controller do

  it 'check for user access' do
    user = FactoryBot.create(:user)
    sign_in user
    get :index
    assert_template :index
  end

  it 'check for admin access' do
    user = FactoryBot.create(:user, admin: true)
    sign_in user
    get :index
    assert_template :index
  end


end
