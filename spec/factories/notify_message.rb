FactoryBot.define do
  factory :notify_message do
    message 'Test'
    begin_at '2018-01-22 08:17:16'
    end_at '2018-02-22 08:17:16'
    created_user_id '1'
    user_id nil
    email 'email@mail.ru'
    phone '123456789'
    theme_id '1'
    all nil
    admin nil
    feed nil
    vpch nil
    mse nil
  end
end
