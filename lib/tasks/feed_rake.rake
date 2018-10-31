namespace :feed_rake do
  task :change_rmis => :environment do
    orgs = []
    Sector.where('lsd_sector_id is not NULL and old is not true').each do |s|
      Doctor.active.where(sector_id: s.id).each do |d|
        lsd_sector_doctor =MdClinicDistrict.find_by_sql(["select srgd.district_id, pe.individual_id, pe.organization_id from sr_res_group_district srgd left join sr_res_group srg on srgd.group_id = srg.id join pim_employee_position pep on pep.id=srg.responsible_id join pim_employee pe on pe.id=pep.employee_id where srgd.district_id = ? and pe.individual_id=? and srgd.edatetime is null", s.lsd_sector_id, d.lsd_id])
        unless lsd_sector_doctor.present?
          orgs << [Organization.find(d.organization_id).name, Sector.find_by_lsd_sector_id(s.lsd_sector_id).name]
        end
      end
    end
    # puts 'orgs'
    # puts orgs
    loc_doc = orgs.inject (Hash.new {|h,k| h[k] = []}) do |m,a|
      m[a.first] << a.last
      m
    end
    # puts 'res'
    # puts res


    doctor = []
    org = []
    Sector.where('lsd_sector_id is not NULL and old is not true').each do |s|
      doc_rmis = MdClinicDistrict.find_by_sql(["select srgd.district_id, pe.individual_id, pe.organization_id, concat(pi.surname,' ',pi.name, ' ', pi.patr_name) from sr_res_group_district srgd left join sr_res_group srg on srgd.group_id = srg.id join pim_employee_position pep on pep.id=srg.responsible_id join pim_employee pe on pe.id=pep.employee_id join pim_individual pi on pi.id = pe.individual_id where srgd.district_id = ? and srgd.edatetime is null", s.lsd_sector_id])
      if doc_rmis.present?
        doc_rmis.each do |dr|
          doc = Doctor.active.where('lsd_id =?', dr.individual_id)
          unless doc.present?
            org << [Organization.find(s.organization_id).name,Sector.find(s.id).name]
            # doctor << [Organization.find(s.organization_id).name,Sector.find(s.id).name]
            doctor << [Sector.find(s.id).name, LsdPatient.find(dr.individual_id).full_name]
            # LsdPatient.find(dr.individual_id).full_name
          end
        end
      end
    end
    doctors = org | doctor
    rmis_doc = doctors.inject (Hash.new {|h,k| h[k] = []}) do |m,a|
      m[a.first] << a.last
      m
    end
    # puts loc_doc

    org_sector = []
    Organization.joins(:sectors).uniq.each do |org|
      sep = MdClinicSeparation.where("lower(md_clinic_separation.name) like '%пед%' and md_clinic_separation.clinic_id =? and md_clinic_district.type_id = 2 AND md_clinic_district.to_dt is NULL", org.lsd_organization_id).joins("JOIN md_clinic_district ON md_clinic_district.separation_id = md_clinic_separation.id").select('md_clinic_district.name, md_clinic_district.id')
      if sep.present?
        sep.each do |f|
          sector = Sector.where('lower(name) like lower(?) and lsd_sector_id = ? and old is false', "%#{f.name.strip}%", f.id)
          # puts 'Участок сравнения: '+Sector.find_by_lsd_sector_id(f.id).name
          unless sector.present?

            puts f.id
            puts f.name
            # puts Sector.find_by_lsd_sector_id(f.id).name

            org_sector << [Organization.find(org.id).name, f.name]
            # org_sector << [Organization.find(org.id).name]

          end
        end
      end
    end
    puts org_sector
    org = org_sector.inject (Hash.new {|h,k| h[k] = []}) do |m,a|
      m[a.first] << a.last
      m
    end
    # puts 'Финальные организации: '+ org

    ApplicationMailer.new_lsd_sector_doctor(loc_doc,rmis_doc,org).deliver if loc_doc.present? || rmis_doc.present? || org.present?
    # MednetMailer.new_lsd_sector_doctor(loc_doc,rmis_doc,org_sector).deliver if loc_doc.present? || rmis_doc.present? || org_sector.present?
  end

  #обновление поля статуса
  task :put_age_status => :environment do
    puts "start at #{Time.now}"
    PatientFeed.all.each do |patient|
      unless patient.age_status == 3
        if LsdPatient.where(id: patient.lsd_id).present?
          lsd_patient = LsdPatient.find(patient.lsd_id)
          case lsd_patient.birth_dt
            when Date.today-6.months+1.day..Date.today
              status = true
              age_status = 1
            when Date.today-1.year-1.day..Date.today-6.months
              status = true
              age_status = 2
            else
              status = false
              age_status = 3
          end
          p=PatientFeed.find(patient.id).update_attributes(age_status: age_status, status: status)
          # puts p.present?
          # puts patient.id if p.present?
        end
      end
    end
    puts "stop at #{Time.now}"
  end

  task :set_doctor_name => :environment do
    Doctor.active.find_each do |doc|
      doc.update_attribute(:name, doc.find_doctor_initname)
    end
  end

  task :set_sector_name => :environment do
    Sector.actual.find_each do |sec|
      puts MdClinicDistrict.find(sec.lsd_sector_id).name.strip
      sec.update_attribute(:name, MdClinicDistrict.find(sec.lsd_sector_id).name.strip)
    end
  end

  #Формирование таблицы статистики из поля age_status
  task :feel_statistic_feed_from_status_age => :environment do
    puts "start at #{Time.now}"
    puts "generation stat table status age"
    organizations = Sector.pluck(:organization_id).uniq
    organizations.each do |org_id|
      sectors = Sector.where(organization_id: org_id).pluck(:id)
      if StatisticFeed.where(organization_id: org_id).present?
      StatisticFeed.find_by_organization_id(org_id).update_attributes(before_6_months_bottled: PatientFeed.where(sector_id: sectors, nurse_id: 2, age_status: 1).count,
                                                                      before_6_months_mixed:   PatientFeed.where(sector_id: sectors, nurse_id: 1, age_status: 1).count,
                                                                      after_6_months_bottled:  PatientFeed.where(sector_id: sectors, nurse_id: 2, age_status: 2).count,
                                                                      after_6_months_mixed:    PatientFeed.where(sector_id: sectors, nurse_id: 1, age_status: 2).count)
      else
        StatisticFeed.create(organization_id: org_id,
                             before_6_months_bottled: PatientFeed.where(sector_id: sectors, nurse_id: 2, age_status: 1).count,
                             before_6_months_mixed:   PatientFeed.where(sector_id: sectors, nurse_id: 1, age_status: 1).count,
                             after_6_months_bottled:  PatientFeed.where(sector_id: sectors, nurse_id: 2, age_status: 2).count,
                             after_6_months_mixed:    PatientFeed.where(sector_id: sectors, nurse_id: 1, age_status: 2).count)
      end

    end
    puts "stop at #{Time.now}"
   FeedReport.reestr_report
  end


end


