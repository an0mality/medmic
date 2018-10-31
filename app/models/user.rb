class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable,  :authentication_keys => [:username]
  # , :validatable
  validates_uniqueness_of :username
  validates_presence_of :encrypted_password
  validates_presence_of :username, :email, :fio, :organization_id, :consent_to_the_processing_of_personal_data, :phone

  has_many :frmr_documents
  has_many :notify_messages

  #Роли соответствуют boolean полям в таблице User. Допишите выборку и метод search, если будете добавлять роли.
  ROLES = {:no => 'Укажите роль', :admin => 'Админ', :vpch => 'ВПЧ', :mse=> 'МСЭ', :feed => 'Детское питание',
           :rmis => 'Аптека', :frmr => 'Регистр врачей ДЛО', :mz=>'МЗ'}

  belongs_to :organization
  has_many :doctors
  has_many :analyses
  has_many :monitorings

  def user_status
    current = User.find(self.id)
    status = [current.fio + '. Доступ:']
    if !current.blocks
      status=current.admin ? status << 'Администратор,' : status
      status=current.mz ? status << 'Отчеты МЗ,' : status
      status=current.moderator ? status << 'Модератор МО,' : status
      status=current.feed ? status << 'Детское питание,' : status
      status=current.vpch ? status << 'ВПЧ,' : status
      status=current.mse ? status << 'ИПРА,' : status
      status=current.rmis ? status << 'Аптека,' : status
      status=current.frmr ? status << 'Регистр врачей ДЛО,' : status
    else
      status << current.fio + 'Заблокирован'
    end
    return status.join(" ").chop
  end

  def self.search params
    if params[:email].present? ||params[:username].present? ||params[:fio].present? ||params[:organization_name].present? || params[:role] != 'no'
      user = User
      user = user.where('lower(email) like lower(?)', "%#{params[:email].strip}%") if params[:email].present?
      user = user.where('lower(username) like lower(?)', "%#{params[:username].strip}%") if params[:username].present?
      user = user.where('lower(fio) like lower(?)', "%#{params[:fio].strip}%") if params[:fio].present?
      user = user.where(admin: true) if params[:role]=='admin'
      user = user.where(vpch: true) if params[:role]=='vpch'
      user = user.where(mse: true) if params[:role]=='mse'
      user = user.where(feed: true) if params[:role]=='feed'
      user = user.where(rmis: true) if params[:role]=='rmis'
      user = user.where(frmr: true) if params[:role]=='frmr'
      user = user.joins(:organization).where('lower(organizations.name) like lower(?)', "%#{params[:organization_name].strip}%" ) if params[:organization_name].present?
    else
      user = nil
    end
    return user
  end

  def roles
    roles = []
    if self.blocks
      roles.push('Блокировка')
    else
      roles.push('Администратор') if self.admin
      roles.push('Модератор МО') if self.moderator
      roles.push('МЗ КО') if self.mz
      roles.push('Детское питание') if self.feed
      roles.push('ВПЧ') if self.vpch
      roles.push('ИПРА инвалидов') if self.mse
      roles.push('Аптека') if self.rmis
      roles.push('Регистр врачей ДЛО') if self.frmr
    end

    return roles.join(',')
  end
end
