class MseReport < ActiveRecord::Base
  
def self.patients_list user, prg_rhbs, district_id, lname
    patients = Prg.search user, prg_rhbs, district_id, lname
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Список пациентов"
    sheet1.pagesetup[:orientation] = :portrait
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.1
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1
    sheet1.row(0).height = 40
    sheet1.column(0).width = 5
    sheet1.column(1).width = 20
    sheet1.column(2).width = 20
    sheet1.column(4).width = 25
    sheet1.column(5).width = 10
    sheet1.column(6).width = 10
    sheet1.column(7).width = 10
    sheet1.column(8).width = 10
    sheet1.column(9).width = 25


    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 8
    format_body_table_3 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin, :size => 8

    sheet1.row(0).default_format =  format_body_table_2

    sheet1.row(0).push "№ п/п", "ФИО", "Дата рождения, СНИЛС", 'Группа инвалидности','Адрес', 'Дата разработки ИПР', 'Номер ИПР','Номер протокола ИПР'
    # if PrgRhb.where(prgid: patients.first.id).present?
    sheet1.row(0).push 'Дата выполнения ИПР', 'Участок обслуживания '
    # end

    row_number = 1

    patients.each do |patient|
      if MsePatient.where(prg_id: patient.id).present?
        lsd_id = MsePatient.find_by_prg_id(patient.id).lsd_id
        if lsd_id.present?&&LsdPatient.where(id: lsd_id).present? && LsdPatient.find(lsd_id).death_dt.present?
          death_dt = LsdPatient.find(lsd_id).death_dt.strftime('%d.%m.%Y')
        else
          death_dt = ''
        end
        date = death_dt =='' ? "#{patient.bdate.strftime('%d.%m.%Y')}" : "#{patient.bdate.strftime('%d.%m.%Y')} - #{death_dt}"
        snils = patient.snils.present? ? "#{patient.snils }" :''
        dis_group = MsePatient.find_by_prg_id(patient.id).disability_group.present? ? "#{MsePatient.find_by_prg_id(patient.id).disability_group}" :'не указана'
        address=patient.mse_patient.address.present? ? patient.mse_patient.address: patient.mse_patient.lsd_patient.present? ? patient.mse_patient.lsd_patient.address : 'Адрес не указан'
        lname = patient.lname.present? ?  patient.lname.strip + ' ' : ''
        fname = patient.fname.present? ?  patient.fname.strip + ' ' : ''
        sname = patient.sname.present? ?  patient.sname.strip : ' '
        fio = lname + fname + sname
        close_dt = ''

        if patient.prg_rhbs.present?
          patient.prg_rhbs.each do |rhb|
            close_dt =close_dt + ' '+ rhb.dt_exc.strftime('%d.%m.%Y')
          end
        end

        if patient.mse_patient.lsd_id.present? && patient.mse_patient.lsd_patient.present?
          sector_name=patient.mse_patient.lsd_patient.sector_name
        else
          sector_name='нет данных'
        end

        sheet1.row(row_number).push row_number,fio , "#{date}, #{snils}", dis_group, address, "#{patient.dt.present? ?  patient.dt.strftime('%d.%m.%Y') : 'не указана' }",
                                    "#{patient.prgnum.present? ? patient.prgnum : 'не указан'}", "#{patient.docnum.present? ? patient.docnum : 'не указан' }",
                                    close_dt, sector_name
        sheet1.row(row_number).height = 30
        sheet1.row(row_number).default_format =  format_body_table_3
        row_number += 1
      end
    end

    FileUtils.mkdir_p("#{Rails.root}/public/mse") unless File.directory?("#{Rails.root}/public/mse")
    export_file_path = [Rails.root, "public", "mse", "list_patients.xls"].join("/")
    book.write export_file_path
  end

  def self.create_table period, rhb_exc
    title_period = (DateTime.now-1.months).strftime('%m.%Y')
    period = Time.parse(period) - 10.months
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "выполнение ИПРА инвалидов"
    sheet1.pagesetup[:orientation] = :landscape
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.1
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1

    format_body_table_1 = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :center, :border => :thin, :size => 8
    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 8
    format_body_table_3 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black,  :border => :thin, :size => 8
    format_body_table_4 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_44, :border => :thin, :size => 8

    sheet1.column(1).width = 50
    for j in 0..2 do
      for i in  0..11 do
        sheet1.row(j).set_format(i, format_body_table_2)
      end
    end


    # sheet1.row(0).default_format =  format_body_table_2
    # sheet1.row(1).default_format =  format_body_table_2
    # sheet1.row(2).default_format = format_body_table_2


    sheet1.row(0).push "№ п/п", "Наименование ЛПУ", "ИПР инвалидов, подлежащие учету. Отчетный период #{title_period}", "", "", "", "", "ИПР инвалидов, подлежащие учету ранее", "", "", "", ""
    sheet1.row(1).push "","", "Выполнено", "","Не выполнено", "","Всего", "Выполнено", "","Не выполнено", "","Всего"
    sheet1.row(2).push "","", "Кол-во", "%","Кол-во", "%","",  "Кол-во", "%","Кол-во", "%"

    row_number = 3

    sheet1.merge_cells(0, 0, 2, 0)
    sheet1.merge_cells(0, 1, 2, 1)
    sheet1.merge_cells(0, 2, 0, 6)
    sheet1.merge_cells(0, 7, 0, 11)
    sheet1.merge_cells(1, 6, 2, 6)
    sheet1.merge_cells(1, 2, 1, 3)
    sheet1.merge_cells(1, 4, 1, 5)
    sheet1.merge_cells(1, 7, 1, 8)
    sheet1.merge_cells(1, 9, 1, 10)
    sheet1.merge_cells(1, 11, 2, 11)

    for i in  2..11 do
      sheet1.row(row_number).set_format(i, format_body_table_3)
    end

    index = 1
    rhb_exc.each do |exc|
      col_1_all = exc.organization.prgs.where('prg.dt>= ? and prg.dt <= ?', period.beginning_of_month.to_date,period.end_of_month.to_date).count
      col_1_closed = exc.organization.prg_rhbs.where('prg.dt>= ? and prg.dt <= ?', period.beginning_of_month.to_date,period.end_of_month.to_date).pluck('prg.id').uniq.count
      col_1_open = col_1_all - col_1_closed
      col_2_all = exc.organization.prgs.where('prg.dt < ?', period.beginning_of_month.to_date).count
      col_2_closed = exc.organization.prg_rhbs.where('prg.dt < ?', period.beginning_of_month.to_date).pluck('prg.id').uniq.count
      col_2_open = col_2_all - col_2_closed
      if col_1_all.to_i != 0 || col_2_all.to_i!=0

        sheet1.row(row_number).push index, exc.scode.strip, col_1_closed, (col_1_all.to_i > 0 ? (col_1_closed.to_f*100/col_1_all.to_f).round(1):'-'),
                                    col_1_open, (col_1_all.to_i > 0 ? (col_1_open.to_f*100/col_1_all.to_f).round(1):'-'), (col_1_all),
                                    col_2_closed, (col_2_all.to_i > 0 ? (col_2_closed.to_f*100/col_2_all.to_f).round(1):'-'),
                                    col_2_open, (col_2_all.to_i > 0 ? (col_2_open.to_f*100/col_2_all.to_f).round(1):'-'), (col_2_all)



        # sheet1.row(row_number).default_format =  format_body_table_1
        sheet1.row(row_number).set_format(0, format_body_table_2)

        sheet1.row(row_number).height = 20
        for i in  2..11 do
          sheet1.row(row_number).set_format(i, format_body_table_3)
        end
        sheet1.row(row_number).set_format(2, format_body_table_2)
        sheet1.row(row_number).set_format(7, format_body_table_2)
        sheet1.row(row_number).set_format(4, format_body_table_4)
        sheet1.row(row_number).set_format(9, format_body_table_4)

        row_number += 1
        index += 1
      end
    end

    FileUtils.mkdir_p("#{Rails.root}/public/mse/report") unless File.directory?("#{Rails.root}/public/mse/report")

    export_file_path = [Rails.root, "public", "mse", 'report', "Отчет по МСЭК.xls"].join("/")
    book.write export_file_path
  end
end
