FactoryBot.define do
  factory :user do
    email 'vpch@mail.ru'
    fio 'vpch'
    login 'vpch_test'
    password '12345678'
    password_confirmation {password}
    confirmation_token 'Fnctc4xPnsMR74uK9g2x'
    confirmed_at '2018-01-16 09:03:52.103981'
    confirmation_sent_at '2018-01-18 07:40:36.149389'
    feed true
  end

  # factory :admin do
  #   email 'admin@mail.ru'
  #   fio 'admin'
  #   username 'admin1'
  #   password '12345678'
  #   password_confirmation {password}
  #   admin true
  # end
end
