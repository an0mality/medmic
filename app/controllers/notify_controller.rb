class NotifyController < ApplicationController

  before_filter :require_permission

  def index
    @notifymessages = NotifyMessage.search(params).paginate(page: params[:page], per_page:10).order('end_at desc,id DESC')
    # @notifymessages = notifymessages
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @notifymessage = NotifyMessage.new
  end

  def edit
    if NotifyMessage.exists?(params[:id]) == false
      notice = 'Запись была не найдена.'
      redirect_to notify_index_path, notice: notice
    else
      @notifymessage = NotifyMessage.find(params[:id])
    end
  end

  def create
    @notifymessage = NotifyMessage.add(params)
    if @notifymessage.present? && @notifymessage.save
      notice = 'Сообщение добавлено'
      redirect_to notify_index_path, notice: notice
    else
      notice = 'Сообщение не добавлено, заполните все поля!'
      render 'new', notice: notice
    end
    # redirect_to notify_index_path, notice: params.require(:notify_message)[:role_or_user]
  end

  def update
    @notifymessage = NotifyMessage.find(params[:id])
    if NotifyMessage.date_validate params
      @notifymessage.update_attributes(vpch: nil,mse: nil,feed: nil,all: nil)
      NotifyMessage.upgrade params
      p=@notifymessage.update_attributes(params_notify)
    else
      redirect_to :back, notice: 'Не соответствуют временные рамки'
    end
    unless p
      redirect_to :back, notice: 'Запись не обновлена (заполните все поля). Проверьте корректность даты'
    else
      redirect_to notify_index_path , notice:  'Данные обновлены'
    end
  end

  def destroy
    @notifymessage = NotifyMessage.destroy(params[:id])
    respond_to do |format|
      format.js
    end
  end

private
  def params_notify
    params.require(:notify_message).permit!
  end

  def require_permission
    if !current_user.admin
      redirect_to root_path, notice: 'У вас нет доступа'
    end
  end
end
