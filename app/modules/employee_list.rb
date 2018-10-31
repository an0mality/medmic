class EmployeeList < ActiveRecord::Base

  def self.users_list current_user
    users = User.where(organization_id: current_user.organization_id).order(:fio)

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Список пользователей Mednet"
    sheet1.pagesetup[:orientation] = :portrait
    sheet1.pagesetup[:adjust_to] = 95
    sheet1.margins[:top] = 0.1
    sheet1.margins[:left] = 0.2
    sheet1.margins[:right] = 0.1
    sheet1.margins[:bottom] = 0.1

    sheet1.row(0).push "Список пользователей для #{current_user.organization.name}"
    sheet1.row(1).push "№ п/п", "ФИО", "Уровень доступа", "Login", "Email", "Контактный телефон"

    sheet1.row(0).height = 40
    sheet1.row(1).height = 22

    sheet1.column(0).width = 5
    sheet1.column(1).width = 25
    sheet1.column(2).width = 30
    sheet1.column(3).width = 20
    sheet1.column(4).width = 20
    sheet1.column(5).width = 15

    sheet1.merge_cells(0, 0, 0, 5)

    format_body_table_1 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin, :size => 12
    format_body_table_2 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :pattern => 1, :pattern_fg_color => :xls_color_34, :border => :thin, :size => 8
    format_body_table_3 = Spreadsheet::Format.new :horizontal_align => :center, :text_wrap => true, :vertical_align => :center,  :color => :black, :border => :thin

    for i in 0..5 do
      sheet1.row(0).set_format(i, format_body_table_1)
    end

    for j in 1..1 do
      for i in 0..5 do
        sheet1.row(j).set_format(i, format_body_table_2)
      end
    end

    row_num = 2

    users.each_with_index do |u, index|

      sheet1.row(row_num).height = 25

      for i in 0..5 do
        sheet1.row(row_num).set_format(i, format_body_table_3)
      end

      sheet1.row(row_num).push (index+1), u.fio, u.roles, u.username, u.email, u.phone

      row_num += 1
    end

    FileUtils.mkdir_p("#{Rails.root}/public/employee") unless File.directory?("#{Rails.root}/public/employee")
    export_file_path = [Rails.root, "public", "employee", "users_list_#{current_user.organization.name}.xls"].join("/")
    book.write export_file_path


  end
end