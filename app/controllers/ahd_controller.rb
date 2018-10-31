class AhdController < ApplicationController

  def convert
    uploaded=params[:file]
    content_type = uploaded.content_type if uploaded.present?
    if params[:file].present? && params[:org_type].present? && params[:inn].present? && params[:kpp].present? && content_type.match('excel')

      folder="#{Rails.root}/public/ahd/#{params[:inn].strip}/"
      FileUtils.mkdir_p("#{folder}") unless File.directory?("#{folder}")


      filename = uploaded.original_filename

      File.open(Rails.root.join(folder, uploaded.original_filename),'wb') do |file|
        file.write(uploaded.read)
      end
      AhdGenerator.create_xml params[:org_type], params[:inn].strip, params[:kpp].strip, filename, folder

      # if File.exist?(Rails.root.join(folder, uploaded.original_filename))
      #   send_file(
      #       folder+'ahd.xml',
      #       filename: "AXD.xml",
      #       type: "application/xml")
      if File.exist?(Rails.root.join(folder, 'ahd.xml'))
        send_file(
            folder+'ahd.xml',
            filename: "AXD.xml",
            type: "application/xml")

      else
        redirect_to ahd_path, notice: 'Загружаемый файл не соответсвует, загрузите файл из БАРСА'

      end
      # FileUtils.rm_r("#{folder}") if File.directory?("#{folder}")
    else
      redirect_to ahd_path, notice: 'Вы заполнили не все поля или загрузили не тот файл.'
    end

    # redirect_to :back

  end

end
