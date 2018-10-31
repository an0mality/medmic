class Admin::OrganizationsController < Admin::ApplicationController

  # load_and_authorize_resource :organization
  before_action :check_admin

  def index
    @organizations = Organization.paginate(page: params[:page], per_page:10).order(created_at: :desc)
  end

  def search
    @organizations = Organization.search(params).paginate(page: params[:page], per_page:10)
  end

  def search_name
    @result = Organization.where('lower(name) like lower(?)', "%#{params[:term].strip}%" ).order(:name).pluck(:name)
    render json: @result
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(org_params)
      redirect_to admin_organizations_path, notice: "#{@organization.name} обновлена"
    else
      render 'edit'
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(org_params)
    if @organization.save
      redirect_to admin_organizations_path, notice: 'Запись создана'
    else
      render 'new'
    end
  end


  def destroy
    a = Organization.check_org(params)
    if a.present?
      redirect_to :back, notice: "Запись #{a.name} удалена!"
    else
      redirect_to admin_organizations_path, notice: 'Запись не может быть удалена'
    end

  end

private

  def org_params
    params.require(:organization).permit(:name, :full_name, :address, :tel_secretary, :type_org_id, :city_id, :web_site, :rhb_exc_id, :frmr_organization_id, :at_vpch, :actual )
  end

end
