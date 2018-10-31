class RequestController < ApplicationController
  load_and_authorize_resource :notify_message

  def index
    request = NotifyMessage.where('end_at > ?', DateTime.now)
    if current_user.admin
      request=request.where(admin: true)
    else
      request=request.where(user_id: current_user.id)
    end
    @requests = request.order('created_at DESC').paginate(page: params[:page], per_page:10)
  end

  def closed
    request = NotifyMessage.where('end_at <= ?', DateTime.now+3.hour)
    if current_user.admin
      request=request.where('admin is true')
    else
      request=request.where(user_id: current_user.id)
    end
    @requests = request.order('end_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @request=NotifyMessage.find(params[:id])
  end

  def new
    @request=NotifyMessage.new
  end

  def edit
    if !current_user.admin
      @request=NotifyMessage.find(params[:id])
    else
      n = 'Запись не может быть отредактирована администратором'
      redirect_to request_index_path, notice: n
    end
  end

  def create
    @request=NotifyMessage.requestnew(params)
    @request.update_phone(params)

    respond_to do |format|
      if @request.save
        ApplicationMailer.new_request(@request).deliver
        format.html {redirect_to(request_index_path, notice: 'Заявка добавлена')}
      else
        format.html {render 'new'}
      end
    end
  end

  def update
    @request = NotifyMessage.find(params[:id])
    unless @request.allow_update
      if @request.update_attributes(params_request)
        n= 'Данные обновлены'
        redirect_to request_index_path , notice: n
      else
        n = 'Запись не обновлена (заполните все поля). Проверьте корректность данных'
        render 'edit', notice: n
      end
    else
      n = 'С момента создания заявки прошло 30 минут, вы не можете её редактировать'
      redirect_to request_index_path ,notice: n
    end
  end

  def destroy
    @request=NotifyMessage.find(params[:id])
    if !current_user.admin
      unless @request.allow_destroy
        if @request.destroy
          n = 'Заявка удалена'
          redirect_to request_index_path, notice: n
        else
          n = 'Заявка не удалена'
          redirect_to request_index_path, notice: n
        end
      else
        n = 'С момента создания заявки прошло 30 минут, вы не можете ее удалить'
        redirect_to request_index_path, notice: n
      end
    else
      n = 'Администратор не может удалить запись'
      redirect_to :back, notice: n
    end
  end

  def closing_request
    @requests = NotifyMessage.find(params[:id])
    unless @requests.allow_closed
      @requests.update_attributes(end_at:DateTime.now)
      notice= 'Заявка закрыта'
      redirect_to :back, notice: notice
    else
      notice='Заявка уже закрыта'
      redirect_to :back, notice:notice
    end
  end

private
  def params_request
    params.require(:notify_message).permit!
  end

end
