class Vpch::ResultController < ApplicationController

  before_action :check_onko_and_spid

  def index
    @registry = Registry.search(params, current_user).where('created_at >= ?', Time.now.beginning_of_year).order('id desc')
    if params[:index].present?
      patients =  LsdPatient.search_info(params)
      if patients.present?
        b = []
        patients.map{|w| b<<w.id}
        @search_name = Analysis.where(patient_id: b).where('registry_id is not null')
      end
    end

  end

  def update
    reestr = Registry.find(params[:id])
    respond_to do |format|
      if reestr.update_attributes(registry_params)
        format.html
        format.json { respond_with_bip(reestr) }
      else
        format.html { render :action => "vpch/result/index" }
        format.json { respond_with_bip(reestr) }
      end
    end
  end

  def show
    @registry = Registry.find(params[:id])
    @analysis = Analysis.where(registry_id: params[:id], error_add: false)
  end

  # проставление/удаление результатов онко
  def add_norma_onko
    registry = Analysis.where(registry_id: params[:id], error_add: false, onko_confirm: false)
    case params[:commit]
      when "Установить всем пациентам реестра значения анализа 'Норма'"
        not_detected = CatCitology.nilm
        if not_detected.present?
          registry.each do |record|
            record.update_attributes(cat_citology_id: not_detected, onko_date: Time.now)
          end
        end
      when 'Очистить результаты анализов'
        registry.each do |record|
          record.update_attributes(cat_citology_id: nil, onko_date: nil)
        end
    end
    redirect_to :back
  end

  # проставление/удаление результатов и спид ключей
  def add_spid_key
    registry = Analysis.where(error_add: false, registry_id: params[:id]).order(:analys_key)
    case params[:commit]
      when 'Присвоить ключ'
        slash_index = params[:key_spid].index('/')
        add_key = params[:key_spid][slash_index+1..-1].to_i
        registry.each do |record|
          key = params[:key_spid][0..slash_index] +  add_key.to_s
          record.update_attributes(key_spid: key) if params[:key_spid].present?
          add_key +=1
        end
      when 'Присвоить ключ и установить результат NotDetected'
        not_detected = CatVpch.where('lower(name) like lower(?)', "%not detected%").first.id
        slash_index = params[:key_spid].index('/')
        add_key = params[:key_spid][slash_index+1..-1].to_i
        if not_detected.present?
          registry.each do |record|
            key = params[:key_spid][0..slash_index] +  add_key.to_s
            record.update_attributes(key_spid: key, cat_vpch_id: not_detected, vpch_date: Time.now)  if params[:key_spid].present?
            add_key +=1
          end
        end
      when 'Установить результат NotDetected без присвоения ключа'
        not_detected = CatVpch.where('lower(name) like lower(?)', "%not detected%").first.id
        if not_detected.present?
          registry.each do |record|
            record.update_attributes(cat_vpch_id: not_detected, vpch_date: Time.now)
          end
        end
      when  'Очистить ключи и результаты'
        if registry.present?
          registry.each do |record|
            record.update_attributes(key_spid: nil, cat_vpch_id: nil, vpch_date: nil)
          end
        end
        flash[:success]='Результаты и ключи удалены'
      when 'Очистить ключи'
        if registry.present?
          registry.each do |record|
            record.update_attributes(key_spid: nil)
          end
        end
        flash[:success]='Ключи удалены'
      when 'Очистить результаты анализов'
        if registry.present?
          registry.each do |record|
            record.update_attributes(cat_vpch_id: nil, vpch_date: nil)
          end
        end
        flash[:success]='Результаты удалены'
    end
    redirect_to :back
  end

  # проставление одобренных результатов и формирование файла с результатами пациентов
  def analys_spid
    records = Analysis.where(registry_id: params[:registry_id])
    if params[:print_array].blank?
      if records.present? && params[:id].present?
        set_null_id = records.pluck(:id) - params[:id]
        Analysis.where(id: set_null_id).each do |record|
          record.update_attribute(:spid_confirm, nil)
        end
        Analysis.where(id: params[:id]).each do |record|
          record.update_attribute(:spid_confirm, true)
        end
      elsif params[:id].blank? && params[:spid_confirm_date].blank?
        records.each do |record|
          record.update_attribute(:spid_confirm, nil)
        end
      elsif params[:spid_confirm_date].present?
        Registry.find(params[:registry_id]).update_attributes(spid_confirm_date: params[:spid_confirm_date])
      end
    elsif params[:print_array].present?
      Vpch.create_form_print(params[:print_array], params[:recep_at], params[:user_id])
    end
    # redirect_to :back
  end

  # отправка на регистрацию реестра
  def send_spid_registry
    u = Registry.find(params[:registry_id]).update_attributes(spid_sent_date: Time.now)
    if u.present?
      redirect_to :back
    end
  end

  # загрузка xls с результатами пациента
  def download_spid_result
    if File.exist?("#{Rails.root}/public/vpch/spid/print.xls")
      send_file(
          "#{Rails.root}/public/vpch/spid/print.xls",
          filename: "print.xls",
          type: "application/xls")
    else
      redirect_to :back, notice: "Сформируйте файл для скачивания"
    end
  end

  # загрузка xls с закладки принятые реестры
  def send_taken_registry
    if File.exist?("#{Rails.root}/public/vpch/spid/Реестры, отправленные на проверку.xls")
      send_file(
          "#{Rails.root}/public/vpch/spid/Реестры, отправленные на проверку.xls",
          filename: "Реестры, отправленные на проверку.xls",
          type: "application/xls")
    end
  end

private

  def registry_params
    params.require(:registry).permit!
  end

end
