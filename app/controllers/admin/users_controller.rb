class Admin::UsersController < Admin::ApplicationController
  before_action :check_admin
  def index


    respond_to do |format|
      format.html {render layout: 'admin'}
      format.js
    end
  end


  def search_login
    @result = User.where('lower(username) like lower(?)', "%#{params[:term].strip}%" ).order(:username).pluck(:username)
    render json: @result
  end

  def search_email
    @result = User.where('lower(email) like lower(?)', "%#{params[:term].strip}%" ).order(:email).pluck(:email)
    render json: @result
  end

  def search_org
    @result = Organization.where('lower(name) like lower(?)', "%#{params[:term].strip}%" ).order(:name).pluck(:name)
    render json: @result
  end

  def search_fio
    @result = User.where('lower(fio) like lower(?)', "%#{params[:term].strip}%" ).order(:fio).pluck(:fio)
    render json: @result
  end

  def update
    user = User.find(params[:id])
    respond_to do |format|
      if user.update_attributes(user_params)
        format.html
        format.json { respond_with_bip(user) }
      else
        format.html { render :action => "admin/users/index" }
        format.json { respond_with_bip(user) }
      end
    end
  end
  def search_user
    @users = User.search params
    respond_to do |format|
      format.js
    end

  end

  private
  def user_params
    params.require(:user).permit!
  end

end
