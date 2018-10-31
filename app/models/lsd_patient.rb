class LsdPatient < LsdConnection
  LsdPatient.table_name = "pim_individual"
  has_one :doctor
  has_one :patient_feed
  has_one :mse_patient

   
  def self.find_fio_from_xml main_hash
    person = main_hash
    if person["FIO"].present?
      fname=person["FIO"]["FirstName"]
      sname=person["FIO"]["SecondName"]
      lname=person["FIO"]["LastName"]
    end
    bday=person["BirthDate"]

    if fname.present? && sname.present? && lname.present? && bday != {"xsd:nil"=>"true"}
      patients=LsdPatient.search_info(index: (lname[0]+fname[0]+sname[0]+bday[8..9]+bday[5..6]+bday[0..3]).to_s, mse: 'mse')
    elsif fname.present? && lname.present? && bday != {"xsd:nil"=>"true"}
      patients=LsdPatient.search_info(index: (lname[0]+fname[0]+bday[8..9]+bday[5..6]+bday[0..3]).to_s, mse: 'mse')
    else
      patients = []
    end
    patients
  end

  def self.find_by_fio main_hash
    person = main_hash["Person"]
    if person["FIO"].present?
      #имя
      fname=person["FIO"]["FirstName"]

      #отчество
      sname=person["FIO"]["SecondName"]

      #фамилия
      lname=person["FIO"]["LastName"]
    end


    if fname.present? && sname.present? && lname.present?
      patients = LsdPatient.where('lower(surname) like lower(?) AND lower(name) like lower(?) AND lower(patr_name) like lower(?)', lname, fname, sname).first(5)
    elsif fname.present? && sname.present?
      patients = LsdPatient.where('lower(surname) like lower(?) AND lower(name) like lower(?)', lname, fname).first(5)
    elsif fname.present?
      patients = LsdPatient.where('lower(surname) like lower(?)', lname).first(5)
    else
      patients = []
    end
    patients
    # [fname, sname,lname]
  end


  def self.find_from_xml main_hash
    snils = main_hash['Person']['SNILS']
    if snils.present? &&  snils != {"xsd:nil"=>"true"}
      if LsdPatient.where(list_snils: snils.delete('-').delete(' ')).present?
        patient = LsdPatient.where(list_snils: snils.delete('-').delete(' '))

      else
        patient = find_fio_from_xml main_hash['Person']
      end
    else
      patient = find_fio_from_xml main_hash['Person']
    end
    patient
  end

end
