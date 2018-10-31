class AhdGenerator < ActiveRecord::Base
  require 'builder'
  def self.create_xml org_type, inn, kpp, filename, folder
      xls = Roo::Spreadsheet.open(folder+filename, extension: :xls)

      str_period = xls.sheet(xls.sheets[0]).row(2)[0]
      str_reg = /(\d{4})-(\d{2})-(\d{1,2})/
      str = str_reg.match(str_period.to_s)

      if str.present?

        org_name =xls.sheet(xls.sheets[0]).row(26)[3].present? ? xls.sheet(xls.sheets[0]).row(26)[3].delete('\"') : ''
        address =xls.sheet(xls.sheets[0]).row(28)[2].present? ? xls.sheet(xls.sheets[0]).row(28)[2].delete('\"') : ''

        if xls.sheets[1].present?
          responsible_post = xls.sheet(xls.sheets[1]).row(40)[3].present? ? xls.sheet(xls.sheets[1]).row(40)[3] : ''
          responsible_fio = xls.sheet(xls.sheets[1]).row(40)[9].present? ? xls.sheet(xls.sheets[1]).row(40)[9] : ''
          if org_name.present? && address.present?

            file = File.new("#{folder}/ahd.xml", "wb")
            xm = ::Builder::XmlMarkup.new( :indent => 2 , target: file)

            period = str_period.strftime('%d%m')
            year = str_period.strftime('%Y')

            xm.instruct!
            xm.report("version"=>"", "period"=>"#{period}", "year"=>"#{year}", "shifr"=>"q_zp_zdrav", "form"=>"1", "code"=>"") {
              xm.title {
                xm.item("value"=>"#{org_name}", "name"=>"name")
                xm.item("value"=>"#{address}", "name"=>"org_address")
                xm.item("value"=>"#{org_type}", "name"=>"org_type")

                xm.item("value"=>"#{responsible_post}", "name"=>"responsible_post")
                xm.item("value"=>"#{responsible_fio}", "name"=>"responsible_fio")

                xm.item("value"=>"#{Time.now.strftime("%d.%m.%Y")}", "name"=>"document_creation_date")
                xm.item("value"=>"#{inn}", "name"=>"inn")
                xm.item("value"=>"#{kpp}", "name"=>"kpp")
              }

              xm.sections {
                xm.section("code"=>"1"){
                  for j in 17..28 do
                    if AhdGenerator.pres_row xls.sheet(xls.sheets[1]).row(j)
                      xm.row("code"=>"#{j-15}"){
                        for i in 3..13  do
                          xm.col("#{xls.sheet(xls.sheets[1]).row(j)[i]}", "code"=>"#{i-2}") if xls.sheet(xls.sheets[1]).row(j)[i].to_f > 0
                        end
                      }
                    end
                  end
                }

              }
            }
            file.close
            # puts 'stop'
          end
        end

    end


  end

  def self.pres_row row
    n =row
    for i in 3..13 do

      return  true if n[i].to_f > 0

    end
    return false
  end
end
