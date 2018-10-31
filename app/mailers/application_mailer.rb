class ApplicationMailer < ActionMailer::Base
  default from: 'rm@xxx.ru'
  layout 'mailer'

  before_filter :admin_recipients, only: [:new_user, :new_request, :new_lsd_sector_doctor,
                                          :alert_mse_access, :notification, :error_routes]

  def new_outcoming_document doc
    @document = doc
    mz_frmr = User.where(mz: true, frmr: true)
    if mz_frmr.present?
      email = mz_frmr.collect(&:email).join(",")
    else
      email = ['frmr@xxx.ru']
    end
    mail(to: email, subject:'Новый документ на сайте Mednet в регистре врачей и фельдшеров, имеющих право выписки льготных рецептов')
  end


  def new_user user
  	@user = user
  	mail(to: @email, subject:'Новый пользователь на сайте')
  end

  def new_request request
    @notify = request
    mail(to: @email, subject:'Новая заявка на сайте Mednet')
  end

  def new_report(report)
    @report = report
    @date = DateTime.now-1.months
    attachments["[МИАЦ] Отчет по МСЭК на #{(I18n.t :standalone_month_names, :scope => :date)[@date.month]} месяц #{@date.year} года.xls"] = File.read("#{Rails.root}/public/mse/report/Отчет по МСЭК.xls")

    mail to: %w(xxx@xxx.ru duleev@xxx.ru),
         subject: "[МИАЦ] Отчет по МСЭК на #{(I18n.t :standalone_month_names, :scope => :date)[@date.month]} месяц #{@date.year} года"

  end

  def new_lsd_sector_doctor(loc_doc,rmis_doc,org)
    @loc_docs = loc_doc
    @lsd_sector_doctor = rmis_doc
    @sectors = org
    mail(to: @email, subject:'[МИАЦ] Изменение участок-врач')
  end

  def alert_mse_access(max)
    @error_time = max
    mail(to: @email, subject: 'Статус доступа ФБ МСЭ')
  end

  def notification(message, user, request)
    @error = message
    @current_user = user
    @request = request
    mail(to: @email, subject: "[MEDNET] #{message}",)
  end

  def error_routes(user, request)
    @current_user = user
    @request = request
    mail(to: @email, subject: "[MEDNET] 404 ОШИБКА",)
  end

  private
    def admin_recipients
      recipients = User.where(admin: true, blocks: false)
      if recipients.present?
        @email = recipients.collect(&:email).join(",")
      else
        @email = ['pr@xxx.ru']
      end
    end
end
