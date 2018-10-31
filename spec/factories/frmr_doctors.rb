FactoryBot.define do
  factory :frmr_doctor do
    code '1612313924'
    surname 'testSurname'
    name 'testName'
    birth (Time.now-30.years)
    frmr_organization_id 12
    employment_date (Time.now-3.days)
    cert_date (Time.now-30.days)
    cert_code '112'

    
  end
end
