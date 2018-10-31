require 'rails_helper'

RSpec.describe Frmr::OutcomingDocumentsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #download" do
    it "returns http success" do
      get :download
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #upload" do
    it "returns http success" do
      get :upload
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
