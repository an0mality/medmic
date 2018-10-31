namespace :mse_rake do
  task :parse => :environment do
    folder="public/mse/upload/all"
    Dir.chdir(folder) do
      Dir.glob("*.xml").each do |file_name|
        puts file_name
        unless MseXml.where(xml_id: file_name).present?
          MseXml.create(xml_id: file_name,is_deleted: false)
          puts 'Файл xml сохранен в MSE_XMLS'
          xml_file =File.open(Rails.root.join(folder, file_name))
          mse = MseXml.where(xml_id: file_name).first
          if xml_file.present?
            main_hash = Hash.from_xml(xml_file)["tIPRA"]
            lsd_id = (LsdPatient.find_from_xml(main_hash) )
            if lsd_id.present?
              mse.update_attribute(:accepted, true)
              puts  'Пациент найден в базе РМИС'
              pat = MsePatient.create_rec(main_hash, lsd_id.last.id, mse.id)
              puts 'Создана запись в PRG с lsd_id'
              if pat.present? && pat.errors.blank?
                mse.update_attributes(create_save: true)
                puts 'Пациент добавлен в MSE_PATIENTS'
                File.delete(Rails.root.join(folder, mse.xml_id))
                mse.update_attributes(is_deleted: true)
                puts 'Файл xml удален'
              end
            else
              puts 'Пациент не найден в базе РМИС'
              pat = MsePatient.create_rec_lsd_nil(main_hash, mse.id)
              puts 'Создана запись в PRG без lsd_id'
              mse.update_attribute(:accepted, true)
              if pat.present? && pat.errors.blank?
                mse.update_attributes(create_save: true)
                puts 'Пациент добавлен в MSE_PATIENTS'
                File.delete(Rails.root.join(folder, mse.xml_id))
                mse.update_attributes(is_deleted: true)
                puts 'Файл xml удален'
              end
            end
            # else
            #   puts 'Найдено соответствие в РМИС, пациент не добавлен'
            # end
          end
        else
          mse = MseXml.where(xml_id: file_name).first
          mse.update_attributes(is_deleted: true)
          File.delete(Rails.root.join(folder, file_name))
          puts 'Файл xml не добавлен и ВОЗМОЖНО удален, т.к. такой файл уже имеется в базе'
        end
      end
    end
  end


  task :report_mz,[:period] => :environment do

    rhb_exc = RhbExc.order(:scode)
    period = DateTime.now-1.months
    MseReport.create_table(period.strftime('%d.%m.%Y'), rhb_exc)
    puts 'Файл создан.'
    ApplicationMailer.new_report(@report).deliver
    puts 'Отправлен.'
  end

  task :alert => :environment do
    ApplicationMailer.alerts.deliver
  end

end


