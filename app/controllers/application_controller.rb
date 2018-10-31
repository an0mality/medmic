class ApplicationController < ActionController::Base

  before_action :notify_messages
  before_action :configure_permitted_parameters, if: :devise_controller?

  begin
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path, :alert => exception.message
    end

    rescue_from StandardError do |exception|
      ApplicationMailer.notification(exception.message.to_s, current_user, request).deliver
      redirect_back(fallback_location: root_path)
    end

  end

  def notify_messages
    @notify=NotifyMessage.find_message(current_user) if current_user.present?
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:fio, :username, :email, :password, :password_confirmation, :remember_me, :organization_id, :phone, :vpch, :feed, :mse)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:fio, :username, :email, :password, :password_confirmation, :remember_me, :organization_id, :phone, :vpch, :feed, :mse, :consent_to_the_processing_of_personal_data)
    end
  end

  def check_mz_vpch
    unless current_user.present? && (current_user.mz && current_user.vpch || current_user.admin)
      redirect_to root_path, notice: 'У вас нет доступа к данному модулю'
    end
  end

  def check_vpch
    unless current_user.present? && (current_user.vpch || current_user.admin)
      redirect_to root_path, notice: 'У вас нет доступа к данному модулю'
    end
  end

  def check_onko_and_spid
    unless current_user.present? && (current_user.onko || current_user.spid || current_user.admin)
      redirect_to root_path, notice: 'У вас нет доступа к данному модулю'
    end
  end

  def check_feed
    unless current_user.present? && (current_user.feed || current_user.admin)
      redirect_to root_path, notice: 'У вас нет доступа к этому разделу'
    end
  end

  def check_frmr
    unless current_user.present? && (current_user.frmr&&!current_user.mz || current_user.admin)
      redirect_to root_path, notice: 'У вас нет доступа к этому разделу'
    end
  end

  def check_mse
    unless current_user.present? && (current_user.mse || current_user.admin || current_user.moderator)
      redirect_to root_path, notice: 'У вас нет доступа к этому разделу'
    end
  end
end
