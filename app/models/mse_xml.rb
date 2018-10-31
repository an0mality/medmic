class MseXml < MseConnection
  MseXml.table_name = "mse_xmls"

  has_one :mse_patient
  validates :xml_id, presence: true, uniqueness: true
  scope :accepted, -> {where(accepted: true)}
  scope :not_accepted, -> {where(accepted: false, is_deleted: false)}
  scope :not_create_patient, -> {where(create_save: false, accepted: false, is_deleted: false)}
  scope :err, -> {where(create_save: false, accepted: false, is_deleted: true)}

  def parse_fail_xml
    folder="public/mse/upload/all"
    info=Hash.new
    if File.exist?(Rails.root.join(folder, self.xml_id))
      xml_file =File.open(Rails.root.join(folder, self.xml_id))
      if xml_file.present?
        main_hash = Hash.from_xml(xml_file)["tIPRA"]
        info['snils'] =main_hash['Person']['SNILS']
        info['lname'] =main_hash['Person']['FIO']['LastName']
        info['fname'] =main_hash['Person']['FIO']['FirstName']
        info['sname'] =main_hash['Person']['FIO']['SecondName']
        info['b_date'] =main_hash['Person']['BirthDate']
        info['ad_patient'] =main_hash['Person']['LivingAddress']['Value']
        info['buro'] =main_hash['Buro']['FullName']
        info['doc_num'] =main_hash['Number']
        info['pro_num'] =main_hash['ProtocolNum']
        info['pro_date'] =main_hash['ProtocolDate']
        info['sent_org'] =main_hash['SentOrgName']
        info['other_sent_org'] =main_hash['MedSection']['SenderMedOrgName']
        info['doctor'] = main_hash["FIOHead"]["SecondName"]
      end
    end
    info
  end

end
