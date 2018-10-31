class FrmrReport < ActiveRecord::Base

  def self.doctors_list current_user
    doctors = FrmrDoctor.where(frmr_organization_id: current_user.organization.frmr_organization_id).order(:surname)

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Список медработников"
    sheet1.pagesetup[:orientation] = :landscape
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.2
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1
    sheet1.row(0).height = 40
    sheet1.row(1).height = 20
    sheet1.row(2).height = 20

    sheet1.column(0).width = 5
    sheet1.column(1).width = 12
    sheet1.column(2).width = 7
    sheet1.column(3).width = 12
    sheet1.column(4).width = 12
    sheet1.column(5).width = 15
    sheet1.column(6).width = 10
    #dlo
    sheet1.column(7).width = 5
    sheet1.column(8).width = 10
    sheet1.column(9).width = 10
    #position
    sheet1.column(10).width = 7
    sheet1.column(11).width = 20
    #date
    sheet1.column(12).width = 10
    sheet1.column(13).width = 10
    #cert
    sheet1.column(14).width = 10
    sheet1.column(15).width = 8
    sheet1.column(16).width = 15
    #category
    sheet1.column(17).width = 5

    sheet1.column(17).width = 5


    format_body_table_1 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin, :size => 12
    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 8
    format_body_table_3 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin

    for i in 0..18 do
      sheet1.row(0).set_format(i, format_body_table_1)
    end

    for j in 1..2 do
      for i in 0..18 do
        sheet1.row(j).set_format(i, format_body_table_2)
      end
    end

    sheet1.row(0).push "Регистр медицинских работников #{current_user.organization.name}"
    sheet1.row(1).push "№ п/п", "СНИЛС","Код", "Фамилия", "Имя", "Отчество", "Дата рождения", "ДЛО","","",'Должность',"",'Дата',"",'Сертификат',"","", 'Кв. кате-гория', 'Совместительство'
    sheet1.row(2).push '','','','','','','',"Приз-нак", "Дата включения", "Дата исключения", "Код", "Наименование", "приема", "увольнения","Дата выдачи", "Код cпец-ти", "Наименование спец-ти","", ""

    sheet1.merge_cells(0, 0, 0, 18)

    #doc
    sheet1.merge_cells(1, 0, 2, 0)
    sheet1.merge_cells(1, 1, 2, 1)
    sheet1.merge_cells(1, 2, 2, 2)
    sheet1.merge_cells(1, 3, 2, 3)
    sheet1.merge_cells(1, 4, 2, 4)
    sheet1.merge_cells(1, 6, 2, 6)
    sheet1.merge_cells(1, 5, 2, 5)
    #dlo
    sheet1.merge_cells(1, 7, 1, 9)
    #position
    sheet1.merge_cells(1, 10, 1, 11)
    #date
    sheet1.merge_cells(1, 12, 1, 13)
    #certificat
    sheet1.merge_cells(1, 14, 1, 16)
    #category
    sheet1.merge_cells(1, 17, 2, 17)

    sheet1.merge_cells(1, 18, 2, 18)


    row_num = 3

    doctors.each_with_index do |doc, index|

      sheet1.row(row_num).height = 35
      for i in 0..18 do
        sheet1.row(row_num).set_format(i, format_body_table_3)
      end
      position = doc.extra_position_name.present? ? doc.position_name+', '+doc.extra_position_name : doc.position_name
      sheet1.row(row_num).push (index+1), doc.snils_format, doc.code, doc.surname, doc.name, doc.patr_name,doc.birth_date, doc.dlo ? "1" : "0" , doc.dlo_reg_date, doc.dlo_unreg_date,
                               doc.position_code, position, doc.employment, doc.dismissal,doc.cert, doc.speciality_code, doc.speciality_name,
                               doc.quality_code, doc.sovmest
      row_num += 1
    end

    FileUtils.mkdir_p("#{Rails.root}/public/frmr") unless File.directory?("#{Rails.root}/public/frmr")
    export_file_path = [Rails.root, "public", "frmr", "doctors_list_#{current_user.organization.name}.xls"].join("/")
    book.write export_file_path

  end
  
  def self.speciality_list params
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Сппециальности"
    sheet1.pagesetup[:orientation] = :portrait
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.2
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1

    sheet1.column(0).width = 5
    sheet1.column(1).width = 15
    sheet1.column(2).width = 60
    sheet1.column(3).width = 15
    sheet1.column(4).width = 15
    sheet1.row(0).height = 40
    sheet1.row(1).height = 40

    format_body_table_1 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin, :size => 10
    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 12
    format_body_table_3 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin


    sheet1.merge_cells(0, 0, 0, 4)
    sheet1.row(0).push "Справочник медицинских специальностей, используемых в ГБУЗ КО 'МИАЦ Калужской области'"
    sheet1.row(1).push "№ п/п", "Код", "Наименование", "Высшее образование", "Среднее специальное образование"
    for i in 0..4 do
      sheet1.row(1).set_format(i, format_body_table_2)
    end
    row_num =2
    FrmrSpeciality.search(params).order(:code).each do |s|
      sheet1.row(row_num).push (row_num-1), s.code, s.name, s.high_name, s.sec_name
      for i in 0..4 do
        sheet1.row(row_num).set_format(i, format_body_table_1)
      end
      sheet1.row(row_num).height = 20
      row_num +=1
    end

    FileUtils.mkdir_p("#{Rails.root}/public/frmr") unless File.directory?("#{Rails.root}/public/frmr")
    export_file_path = [Rails.root, "public", "frmr", "speciality_list.xls"].join("/")
    book.write export_file_path
  end

  def self.organization_list params
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "МО"
    sheet1.pagesetup[:orientation] = :landscape
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.2
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1

    sheet1.column(0).width = 5
    sheet1.column(1).width = 15
    sheet1.column(2).width = 5
    sheet1.column(3).width = 20

    sheet1.column(4).width = 40
    sheet1.column(5).width = 80
    sheet1.column(6).width = 15
    sheet1.column(7).width = 15
    sheet1.column(8).width = 25

    sheet1.column(9).width = 10
    sheet1.column(10).width = 10

    sheet1.row(0).height = 40
    sheet1.row(1).height = 40

    format_body_table_1 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin, :size => 10
    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 12


    sheet1.merge_cells(0, 0, 0,10)
    sheet1.row(0).push "Справочник медицинских организаций, используемых в ГБУЗ КО 'МИАЦ Калужской области'"
    sheet1.row(1).push "№ п/п", "ОГРН", "ОКАТО", "МКод", "Краткое наименование", "Полное наименование", "ИНН", "КПП", "Телефон", "Реорга-низова-на", "ДЛО"
    for i in 0..10 do
      sheet1.row(1).set_format(i, format_body_table_2)
    end
    row_num =2
    FrmrOrganization.search(params).order(:name).order(:old).each do |s|
      sheet1.row(row_num).push (row_num-1), s.ogrn, s.okato, s.mcode, s.name, s.full_name, s.inn, s.kpp,s.phone, s.is_old, s.is_dlo
      for i in 0..10 do
        sheet1.row(row_num).set_format(i, format_body_table_1)
      end
      sheet1.row(row_num).height = 25
      row_num +=1
    end

    FileUtils.mkdir_p("#{Rails.root}/public/frmr") unless File.directory?("#{Rails.root}/public/frmr")
    export_file_path = [Rails.root, "public", "frmr", "organization_list.xls"].join("/")
    book.write export_file_path
  end


end
