class Admin::ApplicationController < ApplicationController
  # layout "admin"
  # layout "application"


  private
  def check_admin
    redirect_to root_path, notice: 'У вас нет доступа к этому разделу' if current_user.present? && !current_user.admin || current_user.blank? || current_user.blocks
  end

  def check_frmr_admin
    redirect_to root_path, notice: 'У вас нет доступа к этому разделу' if current_user.present? &&  !(current_user.admin || current_user.mz&&current_user.frmr) || current_user.blank? || current_user.blocks
  end

  def check_admin_feed
    redirect_to root_path if current_user.present? && !(current_user.admin || current_user.moderator) || current_user.blank? || current_user.blocks
  end

end
