class MsePatient < MseConnection
  MsePatient.table_name = "mse_patients"
  belongs_to :prg
  has_many :prg_rhbs, through: :prg
  belongs_to :organization
  belongs_to :lsd_patient, foreign_key:  'lsd_id'
  belongs_to :mse_xml

  def self.create_rec main_hash, lsd_id, mse_id

    address = main_hash['Person']['LivingAddress']['Value'].present? ? main_hash['Person']['LivingAddress']['Value'] : 'Не указан'
    disability_group = (main_hash['DisabilityGroup'].present? && main_hash['DisabilityGroup']['Value'].present?) ? main_hash['DisabilityGroup']['Value'] : ''

    if main_hash['SentOrgOgrn'].present? && RhbExc.find_org_id_by_ogrn(main_hash['SentOrgOgrn']).present?
      organization_id = RhbExc.find_org_id_by_ogrn main_hash['SentOrgOgrn']

    else
      org_str = main_hash['MedSection']['SenderMedOrgName']

      if org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('РЖД|дорож|Жел|жел')
        organization_id = 14

      elsif org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('обн|Обн|ФМБА')
        organization_id = 13

      elsif org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('ОПБ|копб')
        organization_id = 69

      elsif LsdPatient.find(lsd_id).patient_reg.present?
        organization_id = LsdPatient.find(lsd_id).patient_reg
      elsif address.present? && reg_org_id(address).present?
        organization_id = reg_org_id(address)
      elsif org_str.present? && reg_org_id(org_str).present?
        organization_id = reg_org_id(org_str)
      else
        organization_id = 0
      end
    end


    if main_hash["FIOHead"]["SecondName"].present?
      doctor_str = main_hash["FIOHead"]["SecondName"]
    else
      doctor_str = 'Не указан'
    end





    period_from, period_to, indefinite = MsePatient.period main_hash

    puts period_from
    puts period_to
    puts indefinite




    Prg.create_prg main_hash

    if Prg.where(mseid: MseXml.find(mse_id).xml_id[0..-5].downcase).present?

      prg_id = Prg.find_by_mseid(MseXml.find(mse_id).xml_id[0..-5].downcase).id

      MsePatient.create(lsd_id: lsd_id,
                        actual: false,
                        organization_id: organization_id,
                        mse_xml_id: mse_id,
                        prg_id: prg_id,
                        organization_str: (main_hash["MedSection"]["SenderMedOrgName"]).to_s,
                        doctor_str: doctor_str, address: address, disability_group: disability_group,
                        period_from: period_from, period_to: period_to, indefinite: indefinite

      )
      # ,
      # medic_reab: medic_reab, reconstr_reab: reconstr_reab, orto_reab: orto_reab, address: address)

    end
  end

  def self.create_rec_lsd_nil main_hash, mse_id
    if main_hash['Person']['LivingAddress']['Value'].present?
      address = main_hash['Person']['LivingAddress']['Value']
    else
      address = 'Не указан'
    end
    disability_group = (main_hash['DisabilityGroup'].present? && main_hash['DisabilityGroup']['Value'].present?) ? main_hash['DisabilityGroup']['Value'] : ''
    org_str = main_hash["MedSection"]["SenderMedOrgName"]
    if org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('РЖД')
      organization_id = 14
    elsif org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('обн|Обн|ФМБА|ГУЗ')
      organization_id = 13
    elsif org_str.present? && org_str != {"xsd:nil"=>"true"} && org_str.match('ОПБ|копб')
      organization_id = 69
    elsif address.present? && reg_org_id(address).present?
      organization_id = reg_org_id(address)
    elsif org_str.present? && reg_org_id(org_str).present?
      organization_id = reg_org_id(org_str)
    else
      organization_id = 0
    end
    if main_hash["FIOHead"]["SecondName"].present?
      doctor_str = main_hash["FIOHead"]["SecondName"]
    else
      doctor_str = 'Не указан'
    end
    sent_org = main_hash["MedSection"]["SenderMedOrgName"]
    other_sent_org = main_hash["SentOrgName"]


    period_from, period_to, indefinite = MsePatient.period main_hash

    puts period_from
    puts period_to
    puts indefinite



    Prg.create_prg main_hash
    if Prg.where(mseid: MseXml.find(mse_id).xml_id[0..-5].downcase).present?
      prg_id = Prg.find_by_mseid(MseXml.find(mse_id).xml_id[0..-5].downcase).id
      MsePatient.create(lsd_id: nil,
                        actual: false,
                        organization_id: organization_id,
                        mse_xml_id: mse_id,
                        prg_id: prg_id,
                        organization_str: (main_hash["MedSection"]["SenderMedOrgName"]).to_s,
                        doctor_str: doctor_str, address: address, disability_group: disability_group,
                        period_from: period_from, period_to: period_to, indefinite: indefinite)
    end
  end

  def self.period main_hash
    periods = main_hash["MedSection"]["EventGroups"]["Group"]
    if periods.class.to_s=='Hash'
      if periods["GroupType"]["Id"].to_i==34 && periods["Need"]=='true'
        period_from = periods['PeriodFrom'].present? ? periods['PeriodFrom'] : ''
        period_to = periods['PeriodTo']!= {"xsd:nil"=>"true"} ? periods['PeriodTo']: ''
        indefinite = period_to=='0001-01-01'

      end
    else
      main_hash["MedSection"]["EventGroups"]["Group"].each do |p|
        if p["GroupType"]["Id"].to_i==34 && p["Need"]=='true'
          period_from = p['PeriodFrom'].present? ? p['PeriodFrom'] : ''
          period_to = p['PeriodTo']!= {"xsd:nil"=>"true"} ? p['PeriodTo']: ''
          indefinite = period_to=='0001-01-01'
        end
      end
    end
    return period_from, period_to, indefinite

  end

  def self.reg_org_id address
    if address.match('бын')
      result = 104
    elsif address.match('Бар')
      result = 105
    elsif address.match('Бор')
      result = 106
    elsif address.match('Дзер')
      result = 107
    elsif address.match('Дум')
      result = 108
    elsif address.match('Жук')
      result = 109
    elsif address.match('Жизд')
      result = 110
    elsif address.match('Изн')
      result = 111
    elsif address.match('Коз')
      result = 112
    elsif address.match('Кир')
      result = 113
    elsif address.match('Куй')
      result = 114
    elsif address.match('Люд')
      result = 115
    elsif address.match('Мос')
      result = 116
    elsif address.match('Мал')
      result = 117
    elsif address.match('Мед')
      result = 118
    elsif address.match('Мещ')
      result = 119
    elsif address.match('Мышл')
      result = 120
    elsif address.match('Спас')
      result = 121
    elsif address.match('Сух')
      result = 122
    elsif address.match('Тар')
      result = 123
    elsif address.match('Уль')
      result = 124
    elsif address.match('Фер')
      result = 125
    elsif address.match('Хвас')
      result = 126
    elsif address.match('юх')
      result = 127
    elsif address.match('Крем')
      result = 128
    elsif address.match('УВД')
      result = 129
    elsif address.match('4')
      result = 97
    elsif address.match('5')
      result = 98
    elsif address.match('6')
      result = 15
    end
    return result

  end



end
