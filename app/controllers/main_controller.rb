class MainController < ApplicationController

  before_filter :check_moderator, only: :employee

  def index
  end

  def profile
    if current_user.present?
      @user = current_user
    else
      redirect_to root_path

    end
  end

  def monitoring
    @monitoring = Monitoring.create(date: Time.now, user_id: current_user.present? ? current_user.id : 0, path: params[:path])
  end

  def update_user
    @user = User.find params[:id]

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(@user, :notice => 'Запись обновлена') }
        format.json { respond_with_bip(@user) }
      else
        format.html { render :action => "profile" }
        format.json { respond_with_bip(@user) }
      end
    end
  end

  def employee
    adminmail = User.where(admin: true, blocks: false)

    @employees = User.where('organization_id=? and email not in (?)', current_user.organization_id, adminmail.pluck(:email)).order(:fio)
  end


  def unloading_xls
    EmployeeList.users_list current_user
    if File.exist?("#{Rails.root}/public/employee/users_list_#{current_user.organization.name}.xls")
      send_file(
          "#{Rails.root}/public/employee/users_list_#{current_user.organization.name}.xls",
          filename: "Список пользователей Mednet  для #{current_user.organization.name}.xls",
          type: "application/xls")
    else
      redirect_to :back, notice: "Ошибка формирования файла, сообщите в техническую поддержку"
    end
  end

private
  def user_params
    params.require(:user).permit(:fio, :phone)
  end

  # def mon_params
  #   params.require(:monitoring).permit!
  # end

  def check_moderator
    redirect_to root_path unless current_user.present? && current_user.moderator
  end
end
