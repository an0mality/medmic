require 'rails_helper'

RSpec.describe NotifyController, type: :controller do

  it "should have a current_user" do
    user = FactoryBot.create(:user)
    sign_in user
    expect(subject.current_user).to_not eq(nil)
  end

  it "check for user access closure" do
    user = FactoryBot.create(:user)
    sign_in user
    get 'index'
    expect(response).to_not be_success
  end

  it "check for admin access" do
    user = FactoryBot.create(:user, admin: true)
    sign_in user
    get 'index'
    expect(response).to be_success
  end

end