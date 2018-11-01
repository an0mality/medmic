class Statistic < VpchConnection
  # require "#{Rails.root}/app/helpers/woman_consultation_helper"
  # include WomanConsultationHelper
  # db_magic :connection => :stage
  # attr_accessible :organization_id, :primary_reception, :finished_reception, :date
  Statistic.table_name = 'statistics'

  belongs_to :organization

  def self.find_statistic_primary_reception org_id, start_at, end_at
    count = 0
    if InfoDesk.where(organization_id: org_id).present?

      if start_at.present?
        if end_at.present?
          Statistic.where(organization_id: org_id, date: Time.parse(start_at).beginning_of_day..Time.parse(end_at).end_of_day).each do |statistic|
            count = count + statistic.primary_reception
          end
        else
          count = Statistic.where(organization_id: org_id, date: Time.parse(start_at).beginning_of_day..Time.parse(start_at).end_of_day).first.primary_reception
        end
      end

    end
    return count
  end

  def self.result_scrining_vpch_1 age_start, age_end, organization_id, date_start, date_end
    records = Analysis.where(organization_id: organization_id, reception_at: date_start..date_end, error_add: false).pluck(:patient_id).uniq

    result = {}
    #возраст
    result[:p_1_1] = "#{age_start}-#{age_end}"
    #общее число женщин, прикрепленных к ЛПУ и подлеж скринингу
    result[:p_1_3] = LsdPopulation.count_population(organization_id, age_start, age_end)
    result[:p_1_2]= result[:p_1_3]
    #процент жещин, подлежащих скринингу от общего в регионе
    result[:p_1_4] = (result[:p_1_3].to_f*100/result[:p_1_2].to_f).round(2)
    if records.present?

      #общее число женщин  в регионе
      # result[:p_1_2] = LsdPatient.where(gender_id: 2,  birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day).count


      #приглашенных персонально
      result[:p_1_5_1] = LsdPatient.where(id: records, gender_id: 2,  birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day).count
      # + onko_age_result
      #оппортун скрининг=все первичные обращения
      result[:p_1_5_2] =result[:p_1_5_1]
      #всего персонально+оппорт
      result[:p_1_5_3] = result[:p_1_5_1] + result[:p_1_5_2]
      #100*()перс+оппор)/общее число женщин в регионе
      result[:p_1_6] = (result[:p_1_5_3].to_f/result[:p_1_2].to_f * 100).round(2)
    else
      result[:p_1_5_1] = result[:p_1_5_2]= result[:p_1_5_3] = result[:p_1_6] = 0
    end

    result
  end

  def self.result_scrining_vpch_2 age_start, age_end, organization_id, date_start, date_end
    result = {}
    records = Analysis.where(organization_id: organization_id, reception_at: date_start..date_end, error_add: false).pluck(:patient_id).uniq
    #возраст
    result[:p_1_1] = "#{age_start}-#{age_end}"
    #общее число прикр
    result[:p_1_2] = LsdPopulation.count_population(organization_id, age_start, age_end)
    #подлежащих скринингу
    result[:p_1_3] = result[:p_1_2]
    if records.present?



      #приглашенных, т.е.сущ-щих в нашей базе
      result[:p_1_4_1] = LsdPatient.where(id: records, gender_id: 2,  birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day).count
      #оппорт
      result[:p_1_4_2] = result[:p_1_4_1]
      #оппорт+пригл
      result[:p_1_4_3] = result[:p_1_4_1] + result[:p_1_4_2]
      #подлеж-(оппорт+пригл)
      result[:p_1_5_1] = result[:p_1_3].to_i- result[:p_1_4_1].to_i - result[:p_1_4_2].to_i
      #не явившихся перс приглашенных
      result[:p_1_5_2] = 0
      result[:p_1_6] = (100*(result[:p_1_4_1] + result[:p_1_4_2]) / result[:p_1_3].to_f).round(2)
    else
      result[:p_1_4_1] = result[:p_1_4_2] = result[:p_1_4_3] =  result[:p_1_5_1] = result[:p_1_5_2] = result[:p_1_6] = 0
    end

    return result
  end

  def self.result_scrining_vpch_3 age_start, age_end, organization_id, date_start, date_end
    result = {}

    records = Analysis.where(organization_id: organization_id, reception_at: date_start..date_end, error_add: false, group_age: Analysis.group_age_for_period(age_start)).where("cat_citology_id is not null and cat_citology_id !=148")
    result[:p_1] = "#{age_start}-#{age_end}"

    # pacient_id_array =  LsdPatient.where(id: records.pluck(:patient_id).uniq).where(gender_id: 2, birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day).pluck(:id).uniq

    # if pacient_id_array.present?
    if records.present?
      result[:p_2] = records.where(cat_citology_id: CatCitology.nilm).count
      result[:p_3] = records.where(cat_citology_id: CatCitology.asc).count
      result[:p_4] = records.where(cat_citology_id: CatCitology.cin1).count
      result[:p_5] = records.where(cat_citology_id: CatCitology.cin2).count + records.where(cat_citology_id: CatCitology.cin3).count
      result[:p_6] = records.where(cat_citology_id: CatCitology.cis).count
      result[:p_7] = records.where(cat_citology_id: CatCitology.agus).count
      result[:p_8] = records.where(cat_citology_id: CatCitology.nead).count
    else
      result[:p_2]=result[:p_3]=result[:p_4]=result[:p_5]=result[:p_6]=result[:p_7]=result[:p_8] = 0
    end
    result
  end


  def self.result_scrining_vpch_4 age_start, age_end, organization_id, date_start, date_end
    result = {}
    records = Analysis.where(organization_id: organization_id, reception_at: date_start..date_end, error_add: false, spid_confirm: true, group_age: Analysis.group_age_for_period(age_start)).where("cat_vpch_id is not null and cat_vpch_id != 63")

    result[:p_1] = "#{age_start}-#{age_end}"
    # pacient_id_array =  LsdPatient.where(id: records.pluck(:patient_id).uniq).where(gender_id: 2, birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day).pluck(:id).uniq

    # if pacient_id_array.present?
    if records.present?
      # records = records.where(patient_id: pacient_id_array).select('cat_vpch_id')
      result[:p_2] = records.where(cat_vpch_id: CatVpch.not_detected).count
      result[:p_4] = records.where(cat_vpch_id: CatVpch.hpv16).count
      result[:p_5] = records.where(cat_vpch_id: CatVpch.hpv18).count
      result[:p_6] = records.where(cat_vpch_id: CatVpch.other_hpv).count
      result[:p_7] = records.where(cat_vpch_id: CatVpch.hpv_16_18).count
      result[:p_8] = records.where(cat_vpch_id: CatVpch.other_16).count
      result[:p_9] = records.where(cat_vpch_id: CatVpch.other_18).count
      result[:p_10] = records.where(cat_vpch_id: CatVpch.other_16_18).count
      result[:p_11] = records.where(cat_vpch_id: CatVpch.nead).count

      result[:p_3] = result[:p_4] + result[:p_5] + result[:p_6] + result[:p_7] + result[:p_8] + result[:p_9] + result[:p_10] + result[:p_11]

    else
      result[:p_2]=result[:p_3]=result[:p_4]=result[:p_5]=result[:p_6]=result[:p_7]=result[:p_8]=result[:p_9]=result[:p_10]=result[:p_11] = 0
    end
    result
  end


  def self.result_scrining_vpch_5 age_start, age_end, organization_id, date_start, date_end
    result = {}
    records = Analysis.where("vpch_gistology_id is not null").where(organization_id: organization_id, reception_at: date_start.. date_end, error_add: false, group_age: Analysis.group_age_for_period(age_start))
    result[:p_1] = "#{age_start}-#{age_end}"

    pacient_array =  LsdPatient.where(id: records.pluck(:patient_id).uniq).where(gender_id: 2, birth_dt: Date.today - age_end.years-1.year+1.day..Date.today - age_start.years-1.day)
    # pacient_id_array = pacient_array.pluck(:id).uniq


    # if pacient_array.present?
    if records.present?
      # analysis = records.where(patient_id: pacient_array.pluck(:id).uniq).select('vpch_gistology_id')
      analysis = records.select('vpch_gistology_id')
      result[:p_2] = analysis.where(vpch_gistology_id: VpchGistology.nilm).count
      result[:p_3] = analysis.where(vpch_gistology_id: VpchGistology.cin1).count
      result[:p_4] = analysis.where(vpch_gistology_id: VpchGistology.cin2).count
      result[:p_5] = analysis.where(vpch_gistology_id: VpchGistology.cin3).count
      result[:p_6] = analysis.where(vpch_gistology_id: VpchGistology.micro_cancer).count
      result[:p_7] = analysis.where(vpch_gistology_id: VpchGistology.plosk_cancer).count
      result[:p_8] = analysis.where(vpch_gistology_id: VpchGistology.situ).count
      result[:p_9] = analysis.where(vpch_gistology_id: VpchGistology.jelez_cancer).count
      result[:p_10] = analysis.where(vpch_gistology_id: VpchGistology.another).count
      result[:p_11] = analysis.where(vpch_gistology_id: VpchGistology.nead).count

    else
      result[:p_2]=result[:p_3]=result[:p_4]=result[:p_5]=result[:p_6]=result[:p_7]=result[:p_8]=result[:p_9]=result[:p_10]=result[:p_11]=result[:p_12]=result[:p_13]=0
    end
    result
  end



  def self.result_scrining_vpch_6 organization_id, date_start, date_end

    result = {}
    records = Analysis.where(organization_id: organization_id, reception_at: date_start.. date_end, error_add: false, group_age:[1,2,3,4,5,6]).where("cat_citology_id is not null and cat_citology_id !=148").select('cat_citology_id')


    if records.present?
      result[:p_2] = records.where(cat_citology_id: CatCitology.asc).count
      result[:p_3] = records.where(cat_citology_id: CatCitology.cin1).count
      result[:p_4] = records.where(cat_citology_id: CatCitology.cin2).count
      result[:p_5] = records.where(cat_citology_id: CatCitology.cin3).count
      result[:p_6] = records.where(cat_citology_id: CatCitology.cis).count
      result[:p_7] = records.where(cat_citology_id: CatCitology.agus).count
      result[:p_8] = records.where(cat_citology_id: CatCitology.nilm).count
      result[:p_1] = records.count
          # result[:p_2]+ result[:p_3] +result[:p_4]+ result[:p_5]+ result[:p_6]+ result[:p_7]+ result[:p_8]
    else
      result[:p_1] = result[:p_2]=result[:p_3]=result[:p_4]=result[:p_5]=result[:p_6]=result[:p_7]=result[:p_8] = 0
    end
    result

  end


  def self.result_scrining_vpch_7 organization_id, date_start,  date_end

    result = {}
    records = Analysis.where(organization_id: organization_id, reception_at: date_start..date_end, error_add: false, spid_confirm: true, group_age:[1,2,3,4,5,6]).where("cat_vpch_id is not null and cat_vpch_id != 63")

    if records.present?
      result[:p_1] =  records.pluck(:patient_id).uniq.count
      records = records.select('cat_vpch_id')
      result[:p_2] = records.where(cat_vpch_id: CatVpch.hpv16).count
      result[:p_3] = records.where(cat_vpch_id: CatVpch.hpv18).count
      result[:p_4] = records.where(cat_vpch_id: CatVpch.other_hpv).count
      result[:p_5] = records.where(cat_vpch_id: CatVpch.other_16).count
      result[:p_6] = records.where(cat_vpch_id: CatVpch.other_18).count
      result[:p_7] = records.where(cat_vpch_id: CatVpch.hpv_16_18).count
      result[:p_8] = records.where(cat_vpch_id: CatVpch.other_16_18).count
      result[:p_9] = records.where(cat_vpch_id: CatVpch.not_detected).count
    else
      result[:p_9] = result[:p_1] = result[:p_2] = result[:p_3] = result[:p_4] = result[:p_5] = result[:p_6] = result[:p_7] = result[:p_8]= 0
    end
    result
  end

  def self.result_scrining_diagn age_start, age_end, organization_id, date_start, date_end
    result = {}
    records = Analysis.where(reception_at: date_start..date_end,
                             error_add: false,
                             organization_id: organization_id,
                             group_age: Analysis.group_age_for_period(age_start)).where('cat_citology_id is not null and cat_vpch_id is not null and spid_confirm = true')
    result[:p_1] = "#{age_start}-#{age_end}"

    if records.present?
      analysis_negative_vpch = records.where(cat_vpch_id: CatVpch.not_detected)
      analysis_positive_vpch = records.where(cat_vpch_id: CatVpch.positive)
      result[:p_2] = analysis_positive_vpch.where(cat_citology_id: CatCitology.asc).count
      result[:p_3] = analysis_positive_vpch.where(cat_citology_id: CatCitology.cin1).count
      result[:p_4] = analysis_positive_vpch.where(cat_citology_id: CatCitology.cin2).count
      result[:p_5] = analysis_positive_vpch.where(cat_citology_id: CatCitology.cin3).count
      result[:p_6] = analysis_positive_vpch.where(cat_citology_id: CatCitology.cis).count
      result[:p_7] = analysis_positive_vpch.where(cat_citology_id: CatCitology.agus).count
      result[:p_8] = analysis_positive_vpch.where(cat_citology_id: CatCitology.nilm).count

      result[:p_9] = analysis_negative_vpch.where(cat_citology_id: CatCitology.asc).count
      result[:p_10] = analysis_negative_vpch.where(cat_citology_id: CatCitology.cin1).count
      result[:p_11] = analysis_negative_vpch.where(cat_citology_id: CatCitology.cin2).count
      result[:p_12] = analysis_negative_vpch.where(cat_citology_id: CatCitology.cin3).count
      result[:p_13] = analysis_negative_vpch.where(cat_citology_id: CatCitology.cis).count
      result[:p_14] = analysis_negative_vpch.where(cat_citology_id: CatCitology.agus).count
      result[:p_15] = analysis_negative_vpch.where(cat_citology_id: CatCitology.nilm).count
      result[:p_16] = result[:p_2]+result[:p_3]+result[:p_4]+result[:p_5]+result[:p_6]+result[:p_7]+result[:p_8]+result[:p_9]+
          result[:p_10]+result[:p_11]+result[:p_12]+result[:p_13]+result[:p_14]+result[:p_15]

    else
      result[:p_2]=result[:p_3]=result[:p_4]=result[:p_5]=result[:p_6]=result[:p_7]=result[:p_8]=result[:p_9]=
          result[:p_10]=result[:p_11]=result[:p_12]=result[:p_13]=result[:p_14]=result[:p_15]=result[:p_16]=0
    end
    result
  end

