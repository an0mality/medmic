class Vpch::RegistriesController < ApplicationController

  before_action :check_vpch, except: [:print]
  # load_and_authorize_resource :registry

  def index
    @analyses = Analysis.not_registry.where(organization_id: current_user.organization_id).where(error_add: false).order(:analys_key)
    @registry = Registry.search(params, current_user).where(organization_id: current_user.organization_id).order('created_at desc').first(5)
  end

  def show
    registry = Registry.find(params[:id])
    @analysis = Analysis.where(registry_id: registry.id)
    if @analysis.count == 0
      Registry.find(params[:id]).delete
      redirect_to vpch_registries_path, notice: 'Реестр удален, так как в нем нет ни одного анализа пациента'
    end
  end

  def new
    @registry = Registry.new
    analys = Analysis.where(organization_id: current_user.organization_id).where(error_add: false).order(:analys_key)
    @patients = analys.not_registry
  end

  def create
    if params[:my].length == 0
      redirect_to vpch_registries_path, notice: 'Реестр не создан. Вы не выбрали ни одного пациента.'
    else
      reception_at_array = Analysis.where(id: params[:my]).pluck(:reception_at).sort!
      array_pacients = params[:my]
      registry = Registry.create(name: params[:name],
                                 registry_key: Registry.generate_key_registry(current_user.organization_id,  (Registry.last.present? ? Registry.last.id.next : 1)),
                                 user_id: current_user.id,
                                 date_begin: reception_at_array.first,
                                 date_end: reception_at_array.last,
                                 organization_id: current_user.organization_id)

      array_pacients.each do |analys_id|
        Analysis.find(analys_id).update_attributes(registry_id: registry.id, registry_at: Time.now)
      end
      redirect_to vpch_registries_path , notice: 'Реестр создан'
    end
  end

  def add_to_exist_registry
    if params[:registry_key].present? && params[:patient_id].present?
      registry_id = Registry.find_by_registry_key(params[:registry_key]).id
      if Analysis.where(id: params[:patient_id]).present?
        Analysis.find(params[:patient_id]).update_attributes(registry_id: registry_id, registry_at: Time.now())
      end
    end
    redirect_to :back
  end

  def print
    @patients = Analysis.where(registry_id: params[:id])
  end

  def disband_registry
    error_records = Analysis.where(registry_id: params[:id], error_add: false)
    error_records.each do |record|
      record.update_attributes(registry_id: nil, registry_at: nil)
    end
    Registry.find(params[:id]).delete
    redirect_to :back, notice: 'Реестр расформирован'
  end

end
