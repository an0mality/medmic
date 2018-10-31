class Prg < MseConnection
  Prg.table_name = "prg"
  has_one :mse_patient
  has_many :prg_rhbs, foreign_key:  'prgid'
  has_one :organization, through: :mse_patient

  def self.create_prg main_hash
    if main_hash['DevelopDate'].present?
      if (main_hash['DevelopDate'] rescue false) == {"xsd:nil"=>"true"}
        if main_hash['ProtocolDate'].present? && (Date.parse(main_hash['ProtocolDate']) rescue false) == {"xsd:nil"=>"true"}
          dt = nil
        else
          dt = Date.parse(main_hash['ProtocolDate'])
        end
      else
        dt = main_hash['DevelopDate']
      end
    end

    snils = (main_hash['Person']['SNILS'] != {"xsd:nil"=>"true"} ? main_hash['Person']['SNILS'] : nil)
    lname = main_hash['Person']['FIO']['LastName']
    fname = main_hash['Person']['FIO']['FirstName']
    sname = main_hash['Person']['FIO']['SecondName']

    if (Date.parse(main_hash['Person']['BirthDate']) rescue false) ==  false
      bdate =  nil
    else
      bdate = Date.parse(main_hash['Person']['BirthDate'])
    end

    if sname.present? && sname.strip[-1] == 'ч'
      gndr = 1
    elsif sname.present? && sname.strip[-1] != 'ч'
      gndr = 2
    else
      gndr = main_hash['Person']['IsMale']
    end

    oivid = main_hash['Recipient']['RecipientType']['Id']
    docnum = main_hash['ProtocolNum']

    if (Date.parse(main_hash['ProtocolDate']) rescue false) == false
      docdt = nil
    else
      docdt = Date.parse(main_hash['ProtocolDate'])
    end

    prgnum = main_hash['Number']

    if (Date.parse(main_hash['IssueDate']) rescue false) ==  false
      prgdt = docdt
    else
      prgdt = Date.parse(main_hash['IssueDate'])
    end

    mseid = main_hash['Id']

    if mseid.present? && bdate.present? && docdt.present? && prgdt.present?

      Prg.create(okr_id: 1, nreg: 40, dt: dt, snils: snils,
                 lname: lname, fname: fname,
                 sname: sname, bdate: bdate,
                 gndr: gndr, oivid: 1,
                 docnum: docnum, docdt: docdt, prg: 1,
                 prgnum: prgnum, prgdt: prgdt, mseid: mseid)
    end

  end
end
