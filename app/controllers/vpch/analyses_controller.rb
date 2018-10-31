class Vpch::AnalysesController < ApplicationController

  before_action :check_vpch, except: [:update]
  # load_and_authorize_resource :analysis

  autocomplete :mkb_handbook, :code, :extra_data => [:id, :description]
  def index
    @vpch_patients = LsdPatient.search_info(params)
  end

  def new
    @lsd_patient = LsdPatient.find(params[:lsd_id])
    @diagnostic_first = 'Укажите код по МКБ-10 чтобы увидеть описание диагноза'
    @last_reception = Analysis.no_error.where(patient_id: @lsd_patient.id)
    @form_last = Analysis.where(organization_id: current_user.organization_id, error_add: false, patient_id: params[:lsd_id])
  end

  def update
    analysis = Analysis.find(params[:id])
    respond_to do |format|
      if analysis.update_attributes(analysis_params)
        format.html
        format.json { respond_with_bip(analysis) }
      else
        format.html
        format.json { respond_with_bip(analysis) }
      end
    end
  end


  def print
    @notify=nil
    @analysis = Analysis.find(params[:id])
    @lsd_patient = LsdPatient.find(@analysis.patient_id)

  end

  def create
    @analysis = Analysis.create_analysis(params, current_user)
    if @analysis.save
      # redirect_to new_vpch_analysis_path(lsd_id: @analysis.patient_id), notice: 'Посещение создано'
      if params[:commit] == 'Печать направления на Цитологию'
        params[:to] = 'onko'
        redirect_to print_vpch_analysis_path(@analysis.id, href: params[:href], to: params[:to])
      else
        redirect_to print_vpch_analysis_path(@analysis.id, href: params[:href])
      end
    else
      redirect_to :back, notice: "Заполните поля 'Код по МКБ', 'Cоскоб получен' и 'Дата последней менструации' или 'Менопауза'"
    end
  end

  def last_reception
    @lsd_patient = LsdPatient.find(params[:lsd_id])
    @last_reception = Analysis.no_error.where(patient_id: @lsd_patient.id)
    if @last_reception.last.present?
      cito = CatCitology.where(id: @last_reception.last.cat_citology_id).exists?
      vpch = CatVpch.where(id: @last_reception.last.cat_vpch_id).exists?
      if cito.present?
        @cat_citology = CatCitology.find(@last_reception.last.cat_citology_id)
      end
      if vpch.present?
        @cat_vpch = CatVpch.find(@last_reception.last.cat_vpch_id)
      end
    else
      redirect_to info_vpch_analyses_path(lsd_id: params[:lsd_id]), notice: 'Не удалось найти записи о предыдущем посещении в базе.'
    end
  end

  def update_diagnostic_first
    @diagnostic_first = 'Укажите код по МКБ-10 чтобы увидеть описание диагноза'
    record = MkbHandbook.where(code: params[:id])
    # record = MkbHandbook.where('lower(code) LIKE lower(?)', "%#{params[:mkb_handbook_code]}%")
    @diagnostic_first = record.first.description if record.present?
  end

  def delete_patient_from_reestr
    Analysis.find(params[:id]).update_attributes(registry_id: nil, registry_at: nil)
    redirect_to :back

  end

  def block_patient
    rec = Analysis.find(params[:id])
    respond_to do |format|
      if rec.update_attributes(error_add: true)
        format.html { redirect_to :back, notice: 'Анализ пациента заблокирован' }
      end
    end

  end

  def info
    @lsd_patient = LsdPatient.find(params[:lsd_id])
  end

private

  def analysis_params
    params.require(:analysis).permit!
  end
end
