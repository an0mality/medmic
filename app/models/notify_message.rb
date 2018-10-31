class NotifyMessage < ApplicationRecord

  belongs_to :user
  belongs_to :theme

  validate :field_present
  # validate :user_xor_group

  scope :actual, -> {where('begin_at < ? and end_at > ?', Time.now+3.hour, Time.now+3.hour)}


  Recipient = {:no => 'Укажите получателя', :admin => 'Админ', :vpch => 'ВПЧ', :mse=> 'МСЭ', :feed => 'Детское питание',
               :rmis => 'Аптека', :frmr => 'Регистр мед.работников', :all=>'Все группы', :user => 'Пользователь'}

  def self.requestnew params
    params.require(:notify_message)[:begin_at] = DateTime.now
    params.require(:notify_message)[:end_at] = DateTime.now+1.month
    params.require(:notify_message)[:admin] = true
    NotifyMessage.create(params.require(:notify_message).permit!)

  end

  def self.add params
    if params.require(:notify_message)[:all].present? && params.require(:notify_message)[:all] != 'all'
      params.require(:notify_message)[params.require(:notify_message)[:all]] = true
      params.require(:notify_message)[:all]=nil
    end
    if NotifyMessage.date_validate params
      NotifyMessage.create(params.require(:notify_message).permit!)
    end
  end

  def self.upgrade params
    if params.require(:notify_message)[:all].present? && params.require(:notify_message)[:all] != 'all'
      params.require(:notify_message)[params.require(:notify_message)[:all]] = true
      params.require(:notify_message)[:all]=nil
    end

  end


  def to_notify
    if recipient_user_id.present?
      User.find(recipient_user_id).fio+ '[Пользователь]'
    elsif vpch
      'Группа ВПЧ'
    elsif mse
      'Группа ИПРА'
    elsif feed
      'Группа Детское питание'
    elsif rmis
      'Группа Аптека'
    elsif frmr
      'Группа Регистр мед.работников'
    elsif admin
      'Администратор'
    else
      'Все'
    end
  end

  def allow_closed
    end_at <= DateTime.now
  end

  def allow_update
    created_at + 30.minute <= DateTime.now
  end

  def allow_destroy
    created_at + 30.minute <= DateTime.now
  end

  def self.find_message current_user
    NotifyMessage.actual.where('recipient_user_id =? or admin = ? or vpch = ? or mse = ? or feed = ? or frmr = ? or rmis = ?', current_user.id, current_user.admin, current_user.vpch, current_user.mse, current_user.feed, current_user.frmr, current_user.rmis) + NotifyMessage.actual.where(all: true)
  end

  def update_phone params
    user=User.find(params.require(:notify_message)[:user_id])
    user.update_attributes(phone: params[:phone])
  end
  
  def self.search params
    notify = NotifyMessage
      # notify = notify.order("id DESC, end_at desc") if params[:recipient]=='no'
    notify = notify.where(admin: nil, vpch: nil, feed: nil, all: nil, mse: nil) if params[:recipient]=='user'
    notify = notify.where(admin: true) if params[:recipient]=='admin'
    notify = notify.where(vpch: true) if params[:recipient]=='vpch'
    notify = notify.where(mse: true) if params[:recipient]=='mse'
    notify = notify.where(feed: true) if params[:recipient]=='feed'
    notify = notify.where(rmis: true) if params[:recipient]=='rmis'
    notify = notify.where(frmr: true) if params[:recipient]=='frmr'
    notify = notify.where(all: true) if params[:recipient]=='all'
    notify = notify.where('theme_id=?', params[:theme_id]) if params[:theme_id].present?
    notify
  end

private

  def field_present
    errors.add(:base, 'Даты периода показа сообщения должны быть заполнены') if begin_at.blank? && end_at.blank?
    errors.add(:base, 'Заполните поле сообщения') if message.blank?
    # errors.add(:base, 'Обязательны к заполнению поле e-mail или телефон') if (phone.blank? ^ email.blank?) && (phone.present? || email.present?)
    # errors.add(:base, 'Обязательны к заполнению поле e-mail или телефон') if phone.blank? && email.blank?
    # errors.add(:base, 'Формат e-mail не верен') if email.present? && email.match('@').blank?
  end

  def self.date_validate params
    begin_at = params.require(:notify_message)[:begin_at].to_datetime
    end_at = params.require(:notify_message)[:end_at].to_datetime
    return (begin_at <= end_at)
  end

end
