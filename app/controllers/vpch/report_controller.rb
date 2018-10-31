class Vpch::ReportController < ApplicationController

  before_action :check_mz_vpch

  def index
    if params[:date_beg].present? && params[:date_end].present?
      Vpch.create_xls(params[:organization_id], params[:date_beg], params[:date_end], params[:role])
      redirect_to :back
    end
  end

  def download_svod
    if File.exist?("#{Rails.root}/public/vpch/Сводный отчет.xls")
      send_file(
          "#{Rails.root}/public/vpch/Сводный отчет.xls",
          filename: "Сводный отчет.xls",
          type: "application/xls")
    else
      redirect_to vpch_report_index_path, notice: "Сформируйте файл для скачивания"
    end
  end

  def download_for_lpu
    org_name = Organization.find(params[:org]).name
    if File.exist?("#{Rails.root}/public/vpch/#{org_name}.xls")
      send_file(
          "#{Rails.root}/public/vpch/#{org_name}.xls",
          filename: "#{org_name}.xls",
          type: "application/xls")
    else
      redirect_to vpch_report_index_path, notice: "Сформируйте файл для скачивания"
    end
  end

  def download_for_onko
    if File.exist?("#{Rails.root}/public/vpch/КОКОД_результаты.xls")
      send_file(
          "#{Rails.root}/public/vpch/КОКОД_результаты.xls",
          filename: "КОКОД_результаты.xls",
          type: "application/xls")
    else
      redirect_to vpch_report_index_path, notice: "Сформируйте файл для скачивания"
    end
  end

  def download_for_spid
    if File.exist?("#{Rails.root}/public/vpch/СПИД_результаты.xls")
      send_file(
          "#{Rails.root}/public/vpch/СПИД_результаты.xls",
          filename: "СПИД_результаты.xls",
          type: "application/xls")
    else
      redirect_to vpch_report_index_path, notice: "Сформируйте файл для скачивания"
    end
  end

end
