class Vpch <ActiveRecord::Base

  def self.create_xls org, begin_at, end_at, role

    if org.blank?
      org_id = Organization.at_vpch.pluck(:id)
    else
      org_id = [org.to_i]
    end

    role = role.to_i

    date_start = Time.parse(begin_at).beginning_of_day
    date_end = Time.parse(end_at).end_of_day
    time_beg = I18n.l date_start, format: '%d.%m.%Y'

    time_now = I18n.l date_end, format: '%d.%m.%Y'

    year = I18n.l Time.now, format: '%Y'

    FileUtils.mkdir_p("#{Rails.root}/public/vpch/") unless File.directory?("#{Rails.root}/public/vpch/")
    book = Spreadsheet::Workbook.new

    format = Spreadsheet::Format.new :horizontal_align => :centre, :text_wrap => true, :vertical_align => :top
    format_title = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :top, :weight => :bold, :size => 10
    format_table_head = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                :vertical_align => :center, :border => :thin, :pattern => 1,
                                                :pattern_fg_color => :silver
    format_table_body = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                :vertical_align => :center, :border => :thin
    format_body_good = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 8
    format_body_bad = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :red, :border => :thin, :size => 8

    if role == 4
      sheet1 = book.create_worksheet :name => "Охват"
      sheet1.pagesetup[:orientation] = :landscape


      sheet1.default_format = format
      for t in 2..5 do
        for c1 in 0..7 do
          sheet1.row(t).set_format(c1, format_table_head)
        end
      end
      for c1 in 0..7 do
        sheet1.row(12).default_format = format_table_head
      end
      sheet1.column(0).width = 10
      sheet1.column(1).width = 15
      sheet1.column(2).width = 20
      sheet1.column(3).width = 15
      sheet1.column(4).width = 20
      sheet1.column(5).width = 15
      sheet1.column(6).width = 15
      sheet1.column(7).width = 15
      sheet1.row(3).height = 30
      sheet1.row(4).height = 30
      sheet1.row(5).height = 40


      sheet1.row(0).default_format =  format_title
      sheet1.row(1).default_format = format_title
      sheet1.row(0).push "Охват женского населения региона скринингом РШМ c #{time_beg} по #{time_now}."
      sheet1.row(0).height = 35

      sheet1.row(1).push "Назначение: для координатора программы/специалиста в МЗ"

      if org_id.size == 1 and Organization.where(id: org_id[0]).present?

        sheet1.merge_cells(0, 0, 0, 4)
        sheet1.merge_cells(0, 5, 0, 7)

        sheet1.row(0).push "","","","","Для #{Organization.find(org_id[0]).name}"
      else
        sheet1.merge_cells(0, 0, 0, 7)
      end

      sheet1.merge_cells(1, 0, 1, 7)

      sheet1.row(2).push "1.1", "1.2", "1.3", "1.4", "1.5","" ,"" , "1.6"

      sheet1.row(3).push "Возраст, лет",
                         "Общее число женщин в регионе в #{year} году",
                         "Число женщин, подлежащих скринингу и прикрепленных к медучреждениям, участвующим в программе скрининга в #{year} году",
                         "% женщин, подлежащих скринингу в #{year} году, от общего числа женщин в регионе. Охват программой",
                         "Число женщин, прошедших скрининг в #{year} году",
                         "", "", "% женщин в регионе, прошедших скрининг в #{year} году"


      sheet1.merge_cells(2, 4, 2, 6)
      sheet1.merge_cells(3, 4, 3, 6)
      sheet1.merge_cells(3, 0, 5, 0)
      sheet1.merge_cells(3, 1, 5, 1)
      sheet1.merge_cells(3, 2, 5, 2)
      sheet1.merge_cells(3, 3, 5, 3)
      sheet1.merge_cells(3, 7, 5, 7)


      sheet1.row(4).push "","","","","1.5.1", "1.5.2", "1.5.3"

      sheet1.row(5).push "","","","","Приглашенных персонально в рамках программы скрининга", "Оппортунисти-ческий скрининг", "ВСЕГО"

      j = 6
      for i in 0..4 do
        request = Statistic.result_scrining_vpch_1((25+i*5), (29+i*5), org_id, date_start, date_end)
        sheet1.row(j).push request[:p_1_1], request[:p_1_2].to_i, request[:p_1_3].to_i, request[:p_1_4],
                           request[:p_1_5_1].to_i, request[:p_1_5_2].to_i, request[:p_1_5_3].to_i, request[:p_1_6]

        for c1 in 0..7 do
          sheet1.row(j).set_format(c1, format_table_body)
        end
        j += 1
      end

      sheet1.row(j).push "Всего"

      for c1 in 0..7 do
        sheet1.row(j).set_format(c1, format_table_head)
      end
      i=1
      2.times do
        sheet1.row(j).push find_sum_column_integer(sheet1,i, 6, 11)
        i += 1
      end
      if find_sum_column(sheet1,1, 6, 11) > 0
        r= find_sum_column(sheet1,2, 6, 11)*100/find_sum_column(sheet1,1, 6, 11)
      else
        r = 0
      end
      sheet1.row(j).push r.round(2)

      i=4
      3.times do
        sheet1.row(j).push find_sum_column_integer(sheet1,i, 6, 11)
        i += 1
      end
      if find_sum_column(sheet1,1, 6, 11) > 0
        r=find_sum_column(sheet1,6, 6, 11)*100/find_sum_column(sheet1,1, 6, 11)
      else
        r = 0
      end

      sheet1.row(j).push r.round(2)

      # puts "Generate Table 2"
      sheet2 = book.create_worksheet :name => "Охват прикр.женс.насел-я"
      sheet2.pagesetup[:orientation] = :landscape
      for t in 2..5 do
        for c1 in 0..8 do
          sheet2.row(t).set_format(c1, format_table_head)
        end
      end
      for c1 in 0..8 do
        sheet2.row(11).set_format(c1, format_table_head)
      end
      for t in 6..10 do
        for c1 in 0..8 do
          sheet2.row(t).set_format(c1, format_table_body)
        end
      end
      sheet2.column(0).width = 10
      sheet2.column(1).width = 15
      sheet2.column(2).width = 15
      sheet2.column(3).width = 15
      sheet2.column(4).width = 15
      sheet2.column(5).width = 15
      sheet2.column(6).width = 15
      sheet2.column(7).width = 15
      sheet2.column(8).width = 15
      sheet2.row(3).height = 40
      sheet2.row(5).height = 60
      sheet2.row(0).default_format =  format_title
      sheet2.row(1).default_format = format_title

      sheet2.row(0).push "Охват прикрепленного женского наседения скринингом РШМ c #{time_beg} по #{time_now}"
      sheet2.row(1).push "Назначение: для ответственного лица в медучреждении (заведующий отделением/главный врач)."
      sheet2.merge_cells(0, 0, 0, 8)
      sheet2.merge_cells(1, 0, 1, 8)
      sheet2.row(2).push "2.1", "2.2", "2.3", "2.4","","", "2.5","" , "2.6"
      sheet2.row(3).push "Возраст, лет",
                         "Общее число женщин, прикрепленных к медучреждениям в #{year}  году",
                         "Число женщин, подлежащих скринингу в #{year}  году",
                         "Число женщин, прошедших скрининг в #{year} году", "","",
                         "Число женщин, не прошедших скрининг в #{year} году","",
                         "% женщин, прошедших скрининг от подлежащих ему в #{year} году"
      sheet2.merge_cells(2, 3, 2, 5)
      sheet2.merge_cells(2, 6, 2, 7)
      sheet2.merge_cells(3, 3, 3, 5)
      sheet2.merge_cells(3, 6, 3, 7)
      sheet2.merge_cells(3, 0, 5, 0)
      sheet2.merge_cells(3, 1, 5, 1)
      sheet2.merge_cells(3, 2, 5, 2)
      sheet2.merge_cells(3, 3, 3, 5)
      sheet2.merge_cells(3, 6, 3, 7)
      sheet2.merge_cells(3, 8, 5, 8)

      sheet2.row(4).push "","","","2.4.1", "2.4.2", "2.4.3", "2.5.1", "2.5.2"

      sheet2.row(5).push "","","","Приглашенных персонально в рамках программы скрининга", "Оппортунистический скрининг", "ВСЕГО", "ВСЕГО", "из них персонально приглашенных"
      i = 0
      for i in 0..4 do
        result = Statistic.result_scrining_vpch_2(25+i*5, 29+i*5, org_id, date_start, date_end)
        sheet2.row(i+6).push result[:p_1_1], result[:p_1_2].to_i, result[:p_1_3].to_i, result[:p_1_4_1], result[:p_1_4_2].to_i, result[:p_1_4_3].to_i,
                             result[:p_1_5_1].to_i, result[:p_1_5_2], result[:p_1_6]
        i += 1
      end
      sheet2.row(11).push "Всего"
      i=1
      7.times do
        sheet2.row(11).push find_sum_column_integer(sheet2,i,6,11)
        i += 1
      end
      if find_sum_column(sheet2,2,6,11) > 0
        r = (find_sum_column(sheet2,5,6,11)*100/find_sum_column(sheet2,2,6,11)).round(2)
      else
        r = 0
      end
      sheet2.row(11).push r
    end

    # puts "Generate Table 3"
    if role == 4 || role == 1 || role == 3
      sheet3 = book.create_worksheet :name => "Рез-ты всех цитол. исслед."
      for t in 2..4 do
        for c1 in 0..6 do
          sheet3.row(t).set_format(c1, format_table_head)
        end
      end

      for t in 5..16 do
        for c1 in 0..6 do
          sheet3.row(t).set_format(c1, format_table_body)
        end
        sheet3.row(t).height = 35
      end

      for c1 in 0..6 do
        sheet3.row(16).set_format(c1, format_table_head)
      end
      sheet3.column(0).width = 30
      for e in 1..7 do
        sheet3.column(e).width = 8
      end

      sheet3.row(0).default_format =  format_title
      sheet3.row(1).default_format = format_title
      sheet3.row(0).push "Результаты все цитологических исследований в рамках скрининга c #{time_beg} по #{time_now}"
      sheet3.row(1).push "Назначение: для координатора программы/специалиста МЗ, зав.лабораторией."

      sheet3.merge_cells(0, 0, 0, 7)
      sheet3.merge_cells(1, 0, 1, 7)
      sheet3.merge_cells(2, 1, 2, 6)
      sheet3.merge_cells(3, 0, 4, 0)
      sheet3.merge_cells(3, 1, 3, 6)
      sheet3.row(2).push "3.1", "3.2"
      sheet3.row(3).push "Цитологический диагноз", "Возраст, лет"
      sheet3.row(4).push "",  "25-29","30-34", "35-39", "40-44", "45-49", "ВСЕГО"

      result_25 = Statistic.result_scrining_vpch_3(25, 29, org_id, date_start, date_end)
      result_30 = Statistic.result_scrining_vpch_3(30, 34, org_id, date_start, date_end)
      result_35 = Statistic.result_scrining_vpch_3(35, 39, org_id, date_start, date_end)
      result_40 = Statistic.result_scrining_vpch_3(40, 44, org_id, date_start, date_end)
      result_45 = Statistic.result_scrining_vpch_3(45, 49, org_id, date_start, date_end)

      sheet3.row(5).push "Интраэпителиальных поражений не обнаружено (NILM)", result_25[:p_2], result_30[:p_2], result_35[:p_2],  result_40[:p_2], result_45[:p_2]
      sheet3.row(6).push "ASC-US + ASC-H", result_25[:p_3], result_30[:p_3], result_35[:p_3],  result_40[:p_3], result_45[:p_3]
      sheet3.row(7).push "Интраэпителиальная неоплазия низкой степени (LSIL)", result_25[:p_4], result_30[:p_4], result_35[:p_4],  result_40[:p_4], result_45[:p_4]
      sheet3.row(8).push "Интраэпителиальная неоплазия высокой степени (HSIL)", result_25[:p_5], result_30[:p_5], result_35[:p_5],  result_40[:p_5],  result_45[:p_5]
      sheet3.row(9).push "Раковые клетки плоского эпителия(CIS)",result_25[:p_6], result_30[:p_6], result_35[:p_6],  result_40[:p_6], result_45[:p_6]
      sheet3.row(10).push "Атипия железистых клеток неясного значения (AGUS)", result_25[:p_7], result_30[:p_7], result_35[:p_7],  result_40[:p_7], result_45[:p_7]
      sheet3.row(11).push "Образец неудовлетворительный", result_25[:p_8], result_30[:p_8], result_35[:p_8],  result_40[:p_8], result_45[:p_8]
      sheet3.row(12).push "ВСЕГО"

      for t in 5..11 do
        sheet3.row(t).push find_sum_row(sheet3, t, 1,5)
      end

      i=1
      6.times do
        sheet3.row(12).push find_sum_column_integer(sheet3,i,5,12)
        i += 1
      end

      for c1 in 0..6 do
        sheet3.row(12).set_format(c1, format_table_head)
      end

    end


    if role == 4 || role == 2 || role == 1
      # puts "Generate Table 4"
      sheet4 = book.create_worksheet :name => "Рез-ты исслед. на онкоген.типы ВПЧ"
      sheet4.default_format = format
      sheet4.column(1).width = 22
      sheet4.row(0).height = 25
      sheet4.row(0).default_format =  format_title
      sheet4.row(1).default_format = format_title

      for t in 2..4 do
        for c1 in 0..7 do
          sheet4.row(t).set_format(c1, format_table_head)
        end
      end

      for t in 5..14 do
        for c1 in 0..7 do
          sheet4.row(t).set_format(c1, format_table_body)
        end
        sheet4.row(t).height = 35
      end
      for c1 in 0..7 do
        sheet4.row(15).set_format(c1, format_table_head)
      end
      sheet4.column(0).width = 8

      for e in 2..8 do
        sheet4.column(e).width = 8
      end

      sheet4.row(0).push "Результаты исследований на онкогенные типы ВПЧ в рамках скрининга c #{time_beg} по #{time_now}"
      sheet4.row(1).push "Назначение: для координатора программы/специалиста МЗ, зав.лабораторией."

      sheet4.merge_cells(0, 0, 0, 7)
      sheet4.merge_cells(1, 0, 1, 7)
      sheet4.merge_cells(2, 0, 4, 0)
      sheet4.merge_cells(2, 1, 4, 1)
      sheet4.merge_cells(2, 2, 2, 7)
      sheet4.merge_cells(3, 2, 3, 7)
      sheet4.row(2).push "4.1","Заключение лаборатории", "4.2"
      sheet4.row(3).push "", "", "Возраст, лет"
      sheet4.row(4).push "", "", "25-29","30-34", "35-39", "40-44", "45-49", "ВСЕГО"

      result_25 = Statistic.result_scrining_vpch_4(25, 29, org_id, date_start, date_end)
      result_30 = Statistic.result_scrining_vpch_4(30, 34, org_id, date_start, date_end)
      result_35 = Statistic.result_scrining_vpch_4(35, 39, org_id, date_start, date_end)
      result_40 = Statistic.result_scrining_vpch_4(40, 44, org_id, date_start, date_end)
      result_45 = Statistic.result_scrining_vpch_4(45, 49, org_id, date_start, date_end)

      sheet4.row(5).push "4.1.1", "ДНК ВПЧ ВР не обнаружена", result_25[:p_2], result_30[:p_2], result_35[:p_2],  result_40[:p_2], result_45[:p_2]
      sheet4.row(6).push "4.1.2","ДНК ВПЧ ВР обнаружена", result_25[:p_3], result_30[:p_3], result_35[:p_3],  result_40[:p_3], result_45[:p_3]

      sheet4.row(7).push "4.1.3","Обнаружен ВПЧ 16 типа", result_25[:p_4], result_30[:p_4], result_35[:p_4],  result_40[:p_4], result_45[:p_4]
      sheet4.row(8).push "4.1.4","Обнаружен ВПЧ 18 типа", result_25[:p_5], result_30[:p_5], result_35[:p_5],  result_40[:p_5], result_45[:p_5]
      sheet4.row(9).push "4.1.5","Обнаружена ДНК ВПЧ ВР (прочие)", result_25[:p_6], result_30[:p_6], result_35[:p_6],  result_40[:p_6], result_45[:p_6]
      sheet4.row(10).push "4.1.6", "Обнаружен ВПЧ 16+18 типы", result_25[:p_7], result_30[:p_7], result_35[:p_7],  result_40[:p_7], result_45[:p_7]
      sheet4.row(11).push "4.1.7","Обнаружен ВПЧ 16+прочие типы", result_25[:p_8], result_30[:p_8], result_35[:p_8], result_40[:p_8], result_45[:p_8]
      sheet4.row(12).push "4.1.8","Обнаружен ВПЧ 18+прочие типы", result_25[:p_9], result_30[:p_9], result_35[:p_9],  result_40[:p_9], result_45[:p_9]
      sheet4.row(13).push "4.1.9","Обнаружен ВПЧ 16+18+прочие типы", result_25[:p_10], result_30[:p_10], result_35[:p_10],  result_40[:p_10], result_45[:p_10]
      sheet4.row(14).push "4.1.10","Образец неудовлетворительный", result_25[:p_11], result_30[:p_11], result_35[:p_11],  result_40[:p_11], result_45[:p_11]
      sheet4.row(15).push "4.1.11","ВСЕГО"

      for i in 5..14 do
        sheet4.row(i).push find_sum_row(sheet4, i,2,6)
      end

      i=2
      6.times do
        sheet4.row(15).push find_sum_column_integer(sheet4,i,5,6)
        i += 1
      end
    end
    ## puts "Generate Table 5"
    if role == 4 || role == 1

      sheet5 = book.create_worksheet :name => "Рез-ты гистолог.исслед."
      sheet5.default_format = format
      sheet5.column(0).width = 40
      sheet5.row(5).height = 25
      result_25 = Statistic.result_scrining_vpch_5(25, 29, org_id, date_start, date_end)
      result_30 = Statistic.result_scrining_vpch_5(30, 34, org_id, date_start, date_end)
      result_35 = Statistic.result_scrining_vpch_5(35, 39, org_id, date_start, date_end)
      result_40 = Statistic.result_scrining_vpch_5(40, 44, org_id, date_start, date_end)
      result_45 = Statistic.result_scrining_vpch_5(45, 49, org_id, date_start, date_end)
      sheet5.row(0).default_format =  format_title
      sheet5.row(1).default_format = format_title

      for t in 2..4 do
        for c1 in 0..6 do
          sheet5.row(t).set_format(c1, format_table_head)
        end
      end

      for t in 5..16 do
        for c1 in 0..6 do
          sheet5.row(t).set_format(c1, format_table_body)
        end
        sheet5.row(t).height = 35
      end
      for c1 in 0..6 do
        sheet5.row(17).set_format(c1, format_table_body)
      end
      sheet5.column(0).width = 30
      for e in 1..7 do
        sheet5.column(e).width = 8
      end

      sheet5.row(0).push "Результаты гистологических ислледования в рамках скрининга c #{time_beg} по #{time_now}."
      sheet5.row(1).push "Назначение: для координатора программы/специалиста МЗ, зав.лабораторией."

      sheet5.merge_cells(0, 0, 0, 6)
      sheet5.merge_cells(1, 0, 1, 6)
      sheet5.merge_cells(2, 1, 2, 6)
      sheet5.merge_cells(3, 0, 4, 0)
      sheet5.merge_cells(3, 1, 3, 6)
      sheet5.row(2).push "5.1", "5.2"
      sheet5.row(3).push "Гистологический диагноз", "Возраст, лет"
      sheet5.row(4).push "",  "25-29","30-34", "35-39", "40-44", "45-49", "ВСЕГО"

      sheet5.row(5).push "Интраэпителиального поражения не обнаружено", result_25[:p_2], result_30[:p_2], result_35[:p_2],  result_40[:p_2], result_45[:p_2],  find_sum_row(sheet5, 5,1,6)
      sheet5.row(6).push "CIN 1", result_25[:p_3], result_30[:p_3], result_35[:p_3],  result_40[:p_3], result_45[:p_3],  find_sum_row(sheet5, 7,1,6)
      sheet5.row(7).push "CIN 2", result_25[:p_4], result_30[:p_4], result_35[:p_4],  result_40[:p_4], result_45[:p_4],  find_sum_row(sheet5, 8,1,6)
      sheet5.row(8).push "CIN 3 / Карцинома in citu", result_25[:p_5], result_30[:p_5], result_35[:p_5],  result_40[:p_5], result_45[:p_5], find_sum_row(sheet5, 9,1,6)
      sheet5.row(9).push "Микроинвазивный плоскоклеточный рак", result_25[:p_6], result_30[:p_6], result_35[:p_6],  result_40[:p_6], result_45[:p_6], find_sum_row(sheet5, 10,1,6)
      sheet5.row(10).push "Инвазивный плоскоклеточный рак", result_25[:p_7], result_30[:p_7], result_35[:p_7],  result_40[:p_7], result_45[:p_7], find_sum_row(sheet5, 10,1,6)
      sheet5.row(11).push "Аденокарцинома in situ", result_25[:p_8], result_30[:p_8], result_35[:p_8],  result_40[:p_8], result_45[:p_8], find_sum_row(sheet5, 11,1,6)
      sheet5.row(12).push "Инвазивный железистый рак", result_25[:p_9], result_30[:p_9], result_35[:p_9],  result_40[:p_9], result_45[:p_9], find_sum_row(sheet5, 12,1,6)
      sheet5.row(13).push "Другое. Уточнить диагнозы", result_25[:p_10], result_30[:p_10], result_35[:p_10],  result_40[:p_10], result_45[:p_10], find_sum_row(sheet5, 13,1,6)
      sheet5.row(14).push "Неадекватный материал", result_25[:p_11], result_30[:p_11], result_35[:p_11],  result_40[:p_11], result_45[:p_11], find_sum_row(sheet5, 14,1,6)
      sheet5.row(15).push "ВСЕГО"

      for c1 in 0..6 do
        sheet5.row(15).set_format(c1, format_table_head)
      end

      i=1
      6.times do
        sheet5.row(15).push find_sum_column_integer(sheet5,i,5,14)
        i += 1
      end
    end

    # puts "Generate Table 6"
    if role == 4 || role == 3 || role == 1
      if org_id.size > 1
        sheet6 = book.create_worksheet :name => "Рез-ты цитол.скрининга"
        format_table_body = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                    :vertical_align => :center, :border => :thin, :size => 8
        format_title = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :top, :weight => :bold, :size => 8
        format_table_head = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                    :vertical_align => :center, :border => :thin, :pattern => 1,
                                                    :pattern_fg_color => :silver, :size => 8
        sheet6.default_format = format
        sheet6.column(0).width = 45
        sheet6.row(5).height = 15
        sheet6.margins[:top] = 0.2

        for t in 0..3 do
          sheet6.row(t).default_format =  format_title
        end

        for t in 4..6 do
          for c1 in 0..8 do
            sheet6.row(t).set_format(c1, format_table_head)
          end

        end
        sheet6.row(6).height = 20

        sheet6.row(0).push "Результаты цитологического скрининга методом жидкостной цитологии"
        sheet6.row(1).push "Медицинская организация: Калужский областной клинический онкологический диспансер."
        sheet6.row(2).push "Адрес: г.Калуга, ул.Вишневского, д.1"
        sheet6.row(3).push "Дата: c #{time_beg} по #{time_now}."

        for h in 0..3 do
          sheet6.merge_cells(h, 0, h, 8)
        end

        sheet6.row(4).push "Медицинские организации",  "Коли-чество обсле-дован-ных","Полученные результаты"
        sheet6.merge_cells(4, 0, 6, 0)
        sheet6.merge_cells(4, 1, 6, 1)
        sheet6.merge_cells(4, 2, 4, 8)

        sheet6.row(5).push "","","ASС-US + ASC-H", "LSIL (CINI)", "HSIL","","","", "Норма"

        sheet6.merge_cells(5, 2, 6, 2)
        sheet6.merge_cells(5, 3, 6, 3)
        sheet6.merge_cells(5, 8, 6, 8)
        sheet6.merge_cells(5, 4, 5, 7)

        sheet6.row(6).push "","","", "", "CIN II","CIN III","Карци-нома in situ","AGUS", ""

        sheet6.column(0).width = 30
        for t in 1..8 do
          sheet6.column(t).width = 7
        end
        sheet6.row(6).height = 40
        org_all = Organization.at_vpch
        i = 7
        org_all.each do |org|
          sheet6.row(i).height = 20
          for c1 in 0..8 do
            sheet6.row(i).set_format(c1, format_table_body)
          end
          result = Statistic.result_scrining_vpch_6(org.id, date_start, date_end)
          sheet6.row(i).push "#{org.name}", result[:p_1], result[:p_2], result[:p_3], result[:p_4], result[:p_5], result[:p_6], result[:p_7], result[:p_8]
          i += 1
        end
        for c1 in 0..8 do
          sheet6.row(i).set_format(c1, format_table_head)
        end
        sheet6.row(i).height = 30
        sheet6.row(i).push "Итого по учреждениям:"
        for w in 1..8 do
          sheet6.row(i).push find_sum_column_integer(sheet6, w, 7, i-1)
        end
      end
    end

    if role == 4 || role == 1 || role == 2
# puts "Generate Table 7"
      sheet7 = book.create_worksheet :name => "Рез-ты исслед.на ВПЧ-инфек."
      sheet7.default_format = format
      sheet7.column(0).width = 30
      sheet7.row(5).height = 50
      sheet7.margins[:top] = 0.2

      for t in 0..3 do

        sheet7.row(t).default_format =  format_title
      end

      for t in 4..6 do
        for c1 in 0..9 do
          sheet7.row(t).set_format(c1, format_table_head)
        end
      end
      sheet7.row(6).height = 20
      sheet7.row(0).push "Результаты исследований на ВПЧ-инфекцию высокого онкогенного риска"
      sheet7.row(1).push "Медицинская организация: Калужский областной клинический онкологический диспансер."
      sheet7.row(2).push "Адрес: г.Калуга, ул.Вишневского, д.1"
      sheet7.row(3).push "Отчетный период: c #{time_beg} по #{time_now}."

      for h in 0..3 do
        sheet7.merge_cells(h, 0, h, 9)
      end

      sheet7.row(4).push "Медицинские организации",  "Коли-чество обсле-дован-ных","Полученные результаты"
      sheet7.merge_cells(4, 0, 5, 0)
      sheet7.merge_cells(4, 1, 5, 1)
      sheet7.merge_cells(4, 2, 4, 9)

      sheet7.row(5).push "","","HPV 16", "HPV 18", "Прочие","HPV 16 + прочие","HPV 18 + прочие","HPV 16 + HPV18", "HPV 16 + HPV18 + прочие","ВПЧ отри-цатель-ный"

      for t in 1..9 do
        sheet7.column(t).width = 6
      end
      org_all = org_id
      i = 6
      org_all.each do |id|
        sheet7.row(i).height = 20
        for c1 in 0..9 do
          sheet7.row(i).set_format(c1, format_table_body)
        end
        result = Statistic.result_scrining_vpch_7(id, date_start, date_end)

        sheet7.row(i).push "#{Organization.find(id).name}", result[:p_1], result[:p_2], result[:p_3], result[:p_4], result[:p_5], result[:p_6], result[:p_7], result[:p_8], result[:p_9]
        i += 1
      end

      sheet7.row(i).default_format = format_table_head
      sheet7.row(i).height = 30
      sheet7.row(i).push "Итого по учреждениям:"
      for w in 1..9 do
        sheet7.row(i).push find_sum_column_integer(sheet7, w, 6, i-1)
      end
      for c1 in 0..9 do
        sheet7.row(i).set_format(c1, format_table_head)
      end
    end

    if role == 1 || role == 4
#
#Таблица 8. Статистика по посещениям
      sheet8 = book.create_worksheet :name => "Посещения для ЛПУ"
      sheet8.default_format = format
      sheet8.column(0).width = 10
      sheet8.column(1).width = 40
      sheet8.column(2).width = 15
      sheet8.column(3).width = 15
      sheet8.merge_cells(0,0,0,2)
      sheet8.margins[:top] = 0.2

      sheet8.row(0).push "Посещения для ЛПУ c #{time_beg} по #{time_now}."
      sheet8.row(0).default_format = format_title

      count = 2

      monitoring = Analysis.where(error_add: false, reception_at: date_start..date_end, organization_id: org_id)
      orgs = monitoring.pluck(:organization_id).uniq
      sheet8.column(0).width = 30
      sheet8.column(2).width = 20
      sheet8.column(1).width = 20
      orgs.each do |rec_id|
        if Organization.where(id: rec_id).present? and monitoring.where(organization_id: rec_id).pluck(:user_id).uniq != 0
          sheet8.row(count).push Organization.find(rec_id).name
          sheet8.merge_cells(count, 0, count, 2)
          sheet8.row(count).height = 18

          sheet8.row(count).default_format = format_title
          count += 1

          sheet8.row(count).push  "Врач-акушер-гинеколог", "Кол-во принятых пациентов","Кол-во законченных случаев"
          sheet8.row(count).height = 18
          for c1 in 0..2 do
            sheet8.row(count).set_format(c1, format_table_head)
          end
          count += 1
          users = monitoring.where(organization_id: rec_id).pluck(:user_id).uniq
          if monitoring.where(organization_id: rec_id).present?
            users.each do |user_id|
              if User.where(id: user_id).present?
                name = User.find(user_id).fio
              else
                name = 'Имя не найдено в базе'
              end
              for c1 in 0..2 do
                sheet8.row(count).set_format(c1, format_table_body)
              end
              analysis = Analysis.where(reception_at:date_start..date_end, user_id: user_id, error_add: false)
              sheet8.row(count).push "#{name}", analysis.count,
                                     analysis.where('diagnostic_mkb_handbook_id is not null').count
              count += 1
            end
            analysis = Analysis.where(reception_at:date_start..date_end, organization_id: rec_id, error_add: false)
            for c1 in 0..2 do
              sheet8.row(count).set_format(c1, format_table_head)
            end
            sheet8.row(count).push 'Итого по ЛПУ',analysis.count,
                                   analysis.where('diagnostic_mkb_handbook_id is not null').count
            count = count + 2
          end
        end
      end

    end
    if role.present?
      sheet9 = book.create_worksheet :name => "Диагнозы"
      sheet9.pagesetup[:orientation] = :landscape
      sheet9.pagesetup[:adjust_to] = 95
      sheet9.margins[:top] = 0
      sheet9.margins[:left] = 0.4
      sheet9.margins[:right] = 0.4
      sheet9.margins[:bottom] = 0

      sheet9.default_format = format
      for t in 2..5 do
        for c1 in 0..16 do
          sheet9.row(t).set_format(c1, format_table_head)
        end
      end

      sheet9.column(1).width = 20
      sheet9.column(2).width = 20
      sheet9.column(3).width = 15
      sheet9.column(4).width = 20
      sheet9.column(5).width = 15
      sheet9.column(6).width = 15
      sheet9.column(7).width = 15
      sheet9.row(3).height = 20
      sheet9.row(4).height = 40

      sheet9.row(0).default_format =  format_title
      sheet9.row(1).default_format = format_title
      sheet9.row(0).push "Диагнозы по скринингу РШМ. Отчетный период: c #{time_beg} по #{time_now}."
      sheet9.row(0).height = 15

      sheet9.row(1).push "Назначение: для координатора программы/специалиста в МЗ"

      if org_id.size == 1 and Organization.where(id: org_id[0]).present?

        sheet9.merge_cells(0, 0, 0, 7)
        sheet9.merge_cells(0, 8, 0, 16)

        sheet9.row(0).push "","","","","","",'',"Для #{Organization.find(org_id[0]).name}"
      else
        sheet9.merge_cells(0, 0, 0, 15)
      end

      sheet9.merge_cells(1, 0, 1, 7)

      sheet9.row(2).push "Медицинская организация","Возраст","ВПЧ +","","","","","","","ВПЧ -","","","","","","",  "Коли-чество обсле-дован-ных"
      sheet9.merge_cells(2, 2, 2, 8)
      sheet9.merge_cells(2, 9, 2, 15)
      sheet9.merge_cells(2, 16, 4, 16)

      sheet9.row(3).push "",'',"ASС-US + ASC-H", "LSIL (CINI)", "HSIL","","","", "Норма","ASС-US + ASC-H", "LSIL (CINI)", "HSIL","","","", "Норма", "Всего"

      sheet9.merge_cells(2, 8, 2, 8)
      sheet9.merge_cells(2, 1, 4, 1)
      sheet9.merge_cells(3, 2, 4, 2)
      sheet9.merge_cells(3, 3, 4, 3)
      sheet9.merge_cells(3, 8, 4, 8)
      sheet9.merge_cells(3, 9, 4, 9)
      sheet9.merge_cells(3, 10, 4, 10)
      sheet9.merge_cells(3, 15, 4, 15)
      sheet9.merge_cells(3, 4, 3, 7)
      sheet9.merge_cells(3, 11, 3, 14)
      sheet9.merge_cells(2, 0, 4, 0)
      sheet9.merge_cells(3, 9, 4, 9)
      sheet9.merge_cells(3, 15, 4, 15)
      sheet9.merge_cells(2, 9, 2, 15)
      sheet9.row(4).push "","","",'' ,"CIN II","CIN III","Карци-нома in situ","AGUS", "", "" ,"" ,"CIN II","CIN III","Карци-нома in situ","AGUS", ""

      sheet9.column(0).width = 30
      sheet9.column(1).width = 10

      for t in 2..15 do
        sheet9.column(t).width = 7
      end

      count_line = 5
      org_id.each do |org_id|
        result = Statistic.result_scrining_diagn(25, 29, org_id, date_start, date_end)
        sheet9.row(count_line).push Organization.find(org_id).name, result[:p_1], result[:p_2].to_i, result[:p_3].to_i,
                                    result[:p_4], result[:p_5].to_i, result[:p_6].to_i, result[:p_7].to_i, result[:p_8],
                                    result[:p_9], result[:p_10], result[:p_11].to_i, result[:p_12].to_i, result[:p_13],
                                    result[:p_14].to_i, result[:p_15].to_i,result[:p_16].to_i

        sheet9.merge_cells(count_line, 0, count_line + 4, 0)
        put_format result, sheet9, count_line, format_body_bad, format_body_good, format_table_body
        for c1 in 0..1 do
          sheet9.row(count_line).set_format(c1, format_table_body)
        end
        sheet9.row(count_line).set_format(16, format_table_body)

        count_line += 1
        for i in 1..4 do
          result = Statistic.result_scrining_diagn(25+i*5, 29+i*5, org_id, date_start, date_end)
          sheet9.row(count_line).push '', result[:p_1], result[:p_2].to_i, result[:p_3].to_i,
                                      result[:p_4], result[:p_5].to_i, result[:p_6].to_i, result[:p_7].to_i, result[:p_8],
                                      result[:p_9], result[:p_10], result[:p_11].to_i, result[:p_12].to_i, result[:p_13],
                                      result[:p_14].to_i, result[:p_15].to_i,result[:p_16].to_i
          put_format result, sheet9, count_line, format_body_bad, format_body_good, format_table_body
          for c1 in 0..1 do
            sheet9.row(count_line).set_format(c1, format_table_body)
          end
          sheet9.row(count_line).set_format(16, format_table_body)
          count_line += 1
        end
      end
    end


    if role == 4 || role == 2
      sheet10 = book.create_worksheet :name => "Диагнозы. Персонифицированно"
      sheet10.pagesetup[:orientation] = :landscape
      sheet10.pagesetup[:adjust_to] = 95
      sheet10.margins[:top] = 0
      sheet10.margins[:left] = 0.4
      sheet10.margins[:right] = 0.4
      sheet10.margins[:bottom] = 0
      sheet10.default_format = format
      for c1 in 0..10 do
        sheet10.row(2).set_format(c1, format_table_head)
      end

      sheet10.row(0).default_format =  format_title
      sheet10.row(1).default_format = format_title
      sheet10.row(0).push "Персонифицированные результаты скрининга РШМ. Отчетный период: c #{time_beg} по #{time_now}. *Выборки с обоими отрицательными результатами не рассматриваются"
      sheet10.row(0).height = 15

      sheet10.row(1).push "Назначение: для координатора программы/специалиста в МЗ"


      sheet10.row(2).push '№ п/п','ФИО','Дата рождения','Ключ анализа','Дата обследования','Результат ВПЧ',
                          'Цикл ВКО','Цикл мишени','Результат цит. исследования','Медицинская организация','Врач, направивший на обследование'
      sheet10.row(2).height = 30
      i=3
      count = 1
      analysis = Analysis.where('cat_citology_id is not null and cat_vpch_id is not null and spid_confirm = true').
          where(reception_at: date_start..date_end, error_add: false).where('cat_citology_id >? and cat_vpch_id in (?) or cat_citology_id =? and cat_vpch_id in (?) or cat_citology_id >? and cat_vpch_id =?',
                                                                            CatCitology.nilm, CatVpch.positive, CatCitology.nilm, CatVpch.positive, CatCitology.nilm, CatVpch.not_detected)
      analysis = analysis.where(organization_id:org_id[0]) if org_id.size == 1 and Organization.where(id: org_id[0]).present?
      analysis.order(:reception_at).each do |a|
        if LsdPatient.where(id:a.patient_id).present?
          p = LsdPatient.find(a.patient_id)
          doctor = User.where(id:a.user_id).present? ? a.user.fio : 'Не указан'
          sheet10.row(i).push count,  p.full_name, p.birth_dt.strftime('%d.%m.%Y'),a.key_spid, a.reception_at.strftime('%d.%m.%Y'), a.cat_vpch.name,
                              '','', a.cat_citology.name, a.organization.name, doctor
          sheet10.row(i).height = 20
          for c1 in 0..10 do
            sheet10.row(i).set_format(c1, format_table_body)
          end
          i+=1
          count +=1
        end
      end

      sheet10.column(1).width = 30
      sheet10.column(2).width = 10
      sheet10.column(4).width = 10
      sheet10.column(9).width = 30
      sheet10.column(10).width = 30
      sheet10.merge_cells(0,0,0,10)
      sheet10.merge_cells(1,0,1,10)
      sheet10.column(5).width = 20
      sheet10.column(8).width = 20
    end


    if role == 4 || role ==1
      if org_id.size == 1
        export_file_path = [Rails.root, "public", "vpch", "#{Organization.find(org_id[0]).name}.xls"].join("/")
        book.write export_file_path
      else
        export_file_path = [Rails.root, "public", "vpch", "Сводный отчет.xls"].join("/")
        book.write export_file_path
      end
    elsif role == 3
      export_file_path = [Rails.root, "public", "vpch", "КОКОД_результаты.xls"].join("/")
      book.write export_file_path
    elsif role == 2
      export_file_path = [Rails.root, "public", "vpch", "СПИД_результаты.xls"].join("/")
      book.write export_file_path

    end
  end

  def self.send_spid_registry
    FileUtils.mkdir_p("#{Rails.root}/public/vpch/spid/") unless File.directory?("#{Rails.root}/public/vpch/spid/")
    unless File.exist?("#{Rails.root}/public/vpch/spid/*")
      FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/vpch/spid/*"))
    end
    book = Spreadsheet::Workbook.new
    format = Spreadsheet::Format.new :horizontal_align => :centre, :text_wrap => true, :vertical_align => :top
    format_title = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :bottom, :weight => :bold, :size => 10
    format_table_head = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                :vertical_align => :center, :border => :thin, :pattern => 1,
                                                :pattern_fg_color => :silver
    format_table_body = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true,
                                                :vertical_align => :center, :border => :thin

    time = I18n.l Time.now, format: '%d.%m.%Y'
    sheet1 = book.create_worksheet :name => "Реестры на проверку"
    sheet1.pagesetup[:orientation] = :portrait
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.4
    sheet1.margins[:left] = 0.4
    sheet1.margins[:right] = 0.4
    sheet1.margins[:bottom] = 0.4

    sheet1.default_format = format

    sheet1.row(0).push "Реестры, подлежащие проверке на #{time}"
    sheet1.row(0).default_format = format_title
    sheet1.merge_cells(0,0,0,4)
    sheet1.row(0).height = 30
    sheet1.row(2).height = 40

    sheet1.row(2).push 'N', 'Ключ реестра', 'Организация', 'Поступил в лабораторию', 'Отправлен на регистрацию', 'Дата закрытия реестра'
    sheet1.row(2).default_format = format_table_head
    registries = Registry.where('spid_confirm_date is null and spid_sent_date is not null').order("(spid_sent_number)::Integer DESC")
    count = 3
    registries.each do |reg|
      sheet1.row(count).push reg.spid_sent_number, reg.registry_key, reg.organization.name, reg.spid_sent_date, '', reg.spid_confirm_date
      sheet1.row(count).height = 25
      sheet1.row(count).default_format = format_table_body

      count += 1
    end
    sheet1.column(0).width = 10
    sheet1.column(1).width = 10
    sheet1.column(2).width = 35
    sheet1.column(3).width = 15
    sheet1.column(4).width = 15
    sheet1.column(5).width = 15

    export_file_path = [Rails.root, "public", "vpch", "spid", "Реестры, отправленные на проверку.xls"].join("/")
    book.write export_file_path


  end

  def self.put_format result, sheet9, count_line, format_body_bad, format_body_good, format_table_body
    if result[:p_2].to_i > 0
      sheet9.row(count_line).set_format(2, format_body_bad)
    else
      sheet9.row(count_line).set_format(2, format_table_body)
    end
    if result[:p_3].to_i > 0
      sheet9.row(count_line).set_format(3, format_body_bad)
    else
      sheet9.row(count_line).set_format(3, format_table_body)
    end
    if result[:p_4].to_i > 0
      sheet9.row(count_line).set_format(4, format_body_bad)
    else
      sheet9.row(count_line).set_format(4, format_table_body)
    end
    if result[:p_5].to_i > 0
      sheet9.row(count_line).set_format(5, format_body_bad)
    else
      sheet9.row(count_line).set_format(5, format_table_body)
    end
    if result[:p_6].to_i > 0
      sheet9.row(count_line).set_format(6, format_body_bad)
    else
      sheet9.row(count_line).set_format(6, format_table_body)
    end

    if result[:p_7].to_i > 0
      sheet9.row(count_line).set_format(7, format_body_bad)
    else
      sheet9.row(count_line).set_format(7, format_table_body)
    end

    if result[:p_8].to_i > 0
      sheet9.row(count_line).set_format(8, format_body_bad)
    else
      sheet9.row(count_line).set_format(8, format_table_body)
    end


    if result[:p_9].to_i > 0
      sheet9.row(count_line).set_format(9, format_body_good)
    else
      sheet9.row(count_line).set_format(9, format_table_body)
    end
    if result[:p_10].to_i > 0
      sheet9.row(count_line).set_format(10, format_body_good)
    else
      sheet9.row(count_line).set_format(10, format_table_body)
    end
    if result[:p_11].to_i > 0
      sheet9.row(count_line).set_format(11, format_body_good)
    else
      sheet9.row(count_line).set_format(11, format_table_body)
    end
    if result[:p_12].to_i > 0
      sheet9.row(count_line).set_format(12, format_body_good)
    else
      sheet9.row(count_line).set_format(12, format_table_body)
    end
    if result[:p_13].to_i > 0
      sheet9.row(count_line).set_format(13, format_body_good)
    else
      sheet9.row(count_line).set_format(13, format_table_body)
    end

    if result[:p_14].to_i > 0
      sheet9.row(count_line).set_format(14, format_body_good)
    else
      sheet9.row(count_line).set_format(14, format_table_body)
    end

    if result[:p_15].to_i > 0
      sheet9.row(count_line).set_format(15, format_body_good)
    else
      sheet9.row(count_line).set_format(15, format_table_body)
    end
  end


  def self.find_sum_column sheet, column, row_start, row_end
    sum=0
    row_start.upto(row_end) do |row|
      sum = sum+ sheet.row(row)[column].to_f
    end
    return sum.round(2)
  end

  def self.find_sum_column_integer sheet, column, row_start, row_end
    sum=0
    row_start.upto(row_end) do |row|
      sum = sum+ sheet.row(row)[column].to_i
    end
    return sum
  end


  def self.find_sum_row sheet, row, column_start, column_end
    sum=0
    column_start.upto(column_end) do |column|
      sum = sum+ sheet.row(row)[column].to_i
    end
    sum
  end

  def self.create_form_print patient_array, recep_at, user_id

    count_row = 0
    count_column = 1
    count_row_initial = 0
    rec_at = recep_at


    records_for_print = Analysis.where(id: patient_array).order(:analys_key).pluck(:id)

    FileUtils.mkdir_p("#{Rails.root}/public/vpch/spid/") unless File.directory?("#{Rails.root}/public/vpch/spid/")
    unless File.exist?("#{Rails.root}/public/vpch/spid/*")
      FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/vpch/spid/*"))
    end

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "ВПЧ"
    sheet1.pagesetup[:orientation] = :landscape
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0
    sheet1.margins[:left] = 0.4
    sheet1.margins[:right] = 0.4
    sheet1.margins[:bottom] = 0

    format_title = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center, :weight => :bold, :size => 8

    format_result = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :bottom, :weight => :bold, :size => 8


    format_table = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center, :weight => :bold, :size => 7, :border => :thin

    format_body = Spreadsheet::Format.new :text_wrap => true, :vertical_align => :bottom,  :size => 8, :horizontal_align => :left, :weight => :bold

    format_bottom = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :bottom, :weight => :bold, :size => 6
    format_bottom_contacts = Spreadsheet::Format.new :horizontal_align => :left, :text_wrap => true, :vertical_align => :bottom, :weight => :bold, :size => 7,  :italic => true

    format_info = Spreadsheet::Format.new :text_wrap => true, :vertical_align => :bottom,  :size => 8, :horizontal_align => :left, :weight => :bold

    format_sign = Spreadsheet::Format.new :text_wrap => true, :vertical_align => :bottom,  :size => 7, :horizontal_align => :left

    sheet1.column(1).width = 12
    sheet1.column(2).width = 12
    sheet1.column(3).width = 5
    sheet1.column(4).width = 5
    sheet1.column(5).width = 5
    sheet1.column(6).width = 15

    sheet1.column(8).width = 12
    sheet1.column(9).width = 12

    sheet1.column(11).width = 5
    sheet1.column(12).width = 5
    sheet1.column(13).width = 5
    sheet1.column(14).width = 15

    records_for_print.each do |record|
      patient = Analysis.find(record)

      patient_info = LsdPatient.find(patient.patient_id) if LsdPatient.where(id: patient.patient_id).present?
      docs = LsdPatientDoc.where(indiv_id: patient.patient_id).where('expire_dt is null or expire_dt >=?', Time.now).where(is_active: true)
      passport = docs.where(type_id: 13).first

      # doc_oms = LsdPatient.oms_doc_hash patient_info
      #
      # oms_company = doc_oms[:issuer]
      # oms_number = doc_oms[:number]
      # oms_series = doc_oms[:series]
      # oms_issue_dt = doc_oms[:issue_dt]

      doc_oms = patient_info.polis_doc
      doc_oms.each do |oms|





      if Organization.where(id: patient.organization_id).present?
        lpu = Organization.find(patient.organization_id).name
      else
        lpu = ''
      end

      if User.where(id: patient.user_id).present?
        fio = User.find(patient.user_id).fio
      else
        fio = ''
      end

      reception_at = patient.reception_at

      if CatVpch.where(id: patient.cat_vpch_id).present?
        res = CatVpch.find(patient.cat_vpch_id).name
        descr = CatVpch.find(patient.cat_vpch_id).description
        interpr = CatVpch.find(patient.cat_vpch_id).interpretation
      else
        res = ''
        descr = ''
        interpr = ''
      end

      if CatVpch.where(id: patient.cat_vpch_id).present?
        result = CatVpch.find(patient.cat_vpch_id)
      else
        result = ''
      end

      if CatVpch.where(id: patient.cat_vpch_id).present?
        result = CatVpch.find(patient.cat_vpch_id)
      else
        result = ''
      end

      if patient.key_spid.present?
        key = patient.key_spid
      else
        key = ''
      end

      if patient_info.address.present?
        address = patient_info.address
      else
        address = 'Адрес не указан'
      end

      if count_column == 3
        count_column = 1
        count_row_initial = count_row + 2
      end
      count_row = count_row_initial

      case count_column
        when 1
          c1= 0
          c2= 6
          c3=2
          c4=3
          c5=4
          c6=6
          c7=1
          c8=6
        when 2
          c1= 8
          c2= 14
          c3=10
          c4=11
          c5=12
          c6=14
          c7=9
          c8=14
      end
      count_column += 1

      sheet1.row(count_row).push 'ГАУЗ КО «Калужский областной специализированный центр инфекционных заболеваний и  СПИД»  (г. Калуга, ул. Грабцевское шоссе,   д. 115, тел. 484-2-92-67-24)', '', '', '', '', '' ,'',''
      sheet1.row(count_row).height = 28
      sheet1.merge_cells(count_row,c1,count_row,c2)
      sheet1.row(count_row).default_format = format_title
      count_row += 1

      sheet1.row(count_row).push 'Клинико-диагностическая лаборатория', '', '', '', '', '' ,'',''
      sheet1.merge_cells(count_row,c1,count_row,c2)
      sheet1.row(count_row).height = 15
      sheet1.row(count_row).default_format = format_title

      count_row += 1

      sheet1.row(count_row).push '                                РЕЗУЛЬТАТ ИССЛЕДОВАНИЯ                                                 НА ВЫЯВЛЕНИЕ ДНК 14 ГЕНОТИПОВ ВЫСОКОГО КАНЦЕРОГЕННОГО РИСКА ВИРУСА ПАПИЛЛОМЫ ЧЕЛОВЕКА (16,18,31,33,35,39,45,51,52,56,58,59,66,68) в клинических образцах.', '', '', '', '', '' ,'',''
      sheet1.row(count_row).height = 100
      sheet1.merge_cells(count_row,c1,count_row,c2)
      sheet1.row(count_row).default_format = format_result


      count_row += 1
      sheet1.row(count_row).height = 3
      count_row += 1

      sheet1.row(count_row).push 'Фамилия  ', '',patient_info.surname.mb_chars.upcase.to_s, '', '', '', '', ''
      sheet1.row(count_row).height = 15
      sheet1.merge_cells(count_row,c1,count_row,c1+1)
      sheet1.merge_cells(count_row,c1+2,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push  'имя, отчество ', '', "#{patient_info.name.mb_chars.upcase.to_s}  " + "  #{patient_info.patr_name.mb_chars.upcase.to_s}", '', '', '','', ''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+1)
      sheet1.merge_cells(count_row,c1+2,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push 'Дата рождения(день, месяц, год)', '','',"#{I18n.l patient_info.birth_dt, format: '%d.%m.%Y'}" ,'','', 'Пол женский',''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+2)
      sheet1.merge_cells(count_row,c1+3,count_row,c1+5)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push 'Адрес', "#{address}", '', '', '', '' ,'',''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1+1,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)


      count_row += 1
      sheet1.row(count_row).push 'Паспорт(серия)','',  "#{passport.blank? ? " " : passport.series}", '№',"#{passport.blank? ? " " : passport.number}", '', '', ''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+1)
      sheet1.merge_cells(count_row,c1+4,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)
      sheet1.row(count_row).set_format(c1+3, format_body)

      count_row += 1
      sheet1.row(count_row).push 'кем выдан', "#{passport.blank? ? " " : passport.issuer_text}",'','','дата выдачи', '', "#{passport.blank? ? " " :passport.issue_dt}",''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1+1,count_row,c1+3)
      sheet1.merge_cells(count_row,c1+4,count_row,c1+5)
      sheet1.row(count_row).default_format = format_body
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)
      sheet1.row(count_row).set_format(c1+3, format_body)

      count_row += 1
      sheet1.row(count_row).push 'Полис ОМС номер', '',"#{oms[:number]}",  '', '', '', '', ''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+1)
      sheet1.merge_cells(count_row,c1+2,count_row,c2)
      sheet1.row(count_row).set_format(c1, format_body)
      sheet1.row(count_row).set_format(c1+2, format_info)

      count_row += 1
      sheet1.row(count_row).push 'серия', "#{oms[:series]}", '', 'дата выдачи', '', '', "#{oms[:expire]}",''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1+1,count_row,c1+2)
      sheet1.merge_cells(count_row,c1+3,count_row,c1+5)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)
      sheet1.row(count_row).set_format(c1+3, format_body)

      count_row += 1
      sheet1.row(count_row).push 'страх. компания', '', "#{oms[:org]}", '', '', '', '', ''
      sheet1.row(count_row).height = 20

      sheet1.merge_cells(count_row,c1,count_row,c1+1)
      sheet1.merge_cells(count_row,c1+2,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push 'ЛПУ', "#{lpu}", '', '', '', '', '' ,''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1+1,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push 'Врач, направивший на обcлед.','','',"#{fio}", '', '', '',''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+2)
      sheet1.merge_cells(count_row,c1+3,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).push 'Дата забора материала:','','',"#{I18n.l reception_at, format: '%d.%m.%Y'}", '', '' ,'', ''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+2)
      sheet1.merge_cells(count_row,c1+3,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1

      sheet1.row(count_row).push 'Дата приема материала:','','',"#{rec_at}", '', '' ,'', ''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c1+2)
      sheet1.merge_cells(count_row,c1+3,count_row,c2)
      sheet1.row(count_row).default_format = format_info
      sheet1.row(count_row).set_format(c1, format_body)

      count_row += 1
      sheet1.row(count_row).height = 3
      count_row += 1

      sheet1.row(count_row).push '№ ОБРАЗЦА ', 'РЕЗУЛЬТАТ', 'ИНТЕРПРЕТАЦИЯ','','ПОЯСНЕНИЕ', '', '', ''
      sheet1.row(count_row).height = 25
      sheet1.merge_cells(count_row,c3,count_row,c4)
      sheet1.merge_cells(count_row,c5,count_row,c6)
      for i in c1..c2 do
        sheet1.row(count_row).set_format(i, format_table)
      end

      count_row += 1
      if res.match('овтор').present?
        res = 'Уважаемые коллеги! Необходимо повторить взятие материала!'
        interpr = ''
        descr = ''
      elsif res.match('заморож').present?
        res = 'Уважаемые коллеги! Данная проба заморожена и будет исследована при доставке правильно оформленного реестра и копии страхового полиса, если он зарегистрирован не в Калужской области. Обращаться в кабинет №5 ГАУЗ КО КОСЦИЗ и СПИД. '
        interpr = ''
        descr = ''
      end

      if res.present? && interpr.blank? && descr.blank?
        sheet1.merge_cells(count_row,c7,count_row,c8)
        sheet1.row(count_row).push "#{key}", "#{res}",'','','','','',''
      else
        sheet1.row(count_row).push "#{key}", "#{res}", "#{interpr}",'', "#{descr}",'','',''
        sheet1.merge_cells(count_row,c3,count_row,c4)
        sheet1.merge_cells(count_row,c5,count_row,c6)
      end

      sheet1.row(count_row).height = 60

      for i in c1..c2 do
        sheet1.row(count_row).set_format(i, format_table)
      end

      vpch_date = patient.vpch_date.present? ? "#{I18n.l patient.vpch_date, format: '%d.%m.%Y'}" : ''

      count_row += 1
      sheet1.row(count_row).push 'Дата оформления результата', '', vpch_date, 'Врач',  "#{User.find(user_id).fio}", '','',''
      sheet1.row(count_row).height = 15
      sheet1.merge_cells(count_row,c1,count_row,c1+1)

      sheet1.merge_cells(count_row,c1+4,count_row,c2)
      sheet1.row(count_row).default_format = format_body
      sheet1.row(count_row).set_format(c1, format_sign)
      sheet1.row(count_row).set_format(c1+3, format_sign)
      count_row += 1

      sheet1.row(count_row).height = 3
      count_row += 1


      sheet1.row(count_row).push 'ВНИМАНИЕ! КАК В СЛУЧАЕ ЛЮБОГО ДИАГНОСТИЧЕСКОГО ТЕСТА, РЕЗУЛЬТАТЫ АНАЛИЗА Abbott RealTime HR HPV ДОЛЖНЫ ИНТЕРПРЕТИРОВАТЬСЯ В СОЧЕТАНИИ С ДРУГИМИ КЛИНИЧЕСКИМИ И ЛАБОРАТОРНЫМИ ПОКАЗАТЕЛЯМИ!', '', '', '', '', '' ,'',''
      sheet1.row(count_row).height = 25
      sheet1.merge_cells(count_row,c1,count_row,c2)
      sheet1.row(count_row).default_format = format_bottom
      count_row += 1

      sheet1.row(count_row).push 'Контактные лица: врач Комарова Татьяна Геннадиевна, врач Шарапова Наталья Михайловна, тел.: 92-67-24', '', '', '', '', '' ,'',''
      sheet1.row(count_row).height = 20
      sheet1.merge_cells(count_row,c1,count_row,c2)
      sheet1.row(count_row).default_format = format_bottom_contacts
    end
    end

    export_file_path = [Rails.root, "public", "vpch", "spid", "print.xls"].join("/")
    book.write export_file_path

  end



end