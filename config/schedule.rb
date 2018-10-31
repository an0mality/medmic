# # Use this file to easily define all of your cron jobs.
# #
# # It's helpful, but not entirely necessary to understand cron before proceeding.
# # http://en.wikipedia.org/wiki/Cron
#
# # Example:
# #
#  set :output, "~/log/cron_log.log"
#
#Отправляем бэкапы бд mednet,mse,kid,woman_consultation на 10.2.1.246
set :environment, 'production'
every '*/58 8-20 * * 1-5' do
  command '/home/minisrv/cronscript/copy_backup_to_246.sh'
end

#Каждый месяц отправляем отчет по МСЭ в МЗ
every '30 7 7 * *' do
  rake 'mse_rake:report_mz'
end

#Каждый день в 5-30 парсим xml-файлы с ИПРА инвалидов из папки public/mse/upload/all, которые попадают туда с 10,3,1,211 из install/МСЭ/xml/ из последней папки по дате
every '30 5 * * *' do
  rake 'mse_rake:parse'
end

#Каждый день с пн по пт в 8-30 проверяем изменения в базе РМИС соотношения участков-врачей по детскому питанию
every '30 8,15 * * 1-5' do
  rake 'feed_rake:change_rmis'
end

#Каждый день с пн по пт в 9-00, 14-00 и 17-00 создаем файл с полным списком врачей Регистра врачей и фельдшеров, имеющих право выписки льготных рецептов
every '0 9,14,17 * * 1-5' do
  rake 'frmr_rake:all_doctor_report'
end

#Каждый день с пн по пт в 16-00 проверяем выгрузку ФБ МСЭ из базы mse ФБ МСЭ
every '0 16 * * 1-5' do
  rake 'mse_rake:access'
end

#Каждые полчаса с 8 до 20 создаем последние бэкапы баз данных в папку ~/backup/last
every '*/30 8-20 * * *' do
  command '/home/minisrv/cronscript/backup_last.sh'
end

#Раз в день в 20 с пн по сб создаем бэкапы БД
every '0 20 * * 1-6' do
  command '/home/minisrv/cronscript/backup_day.sh'
end

#Удаляем самые старые бэкапы
every '* 14,21 * * 1-6' do
  command '~/cronscript/removelast_day.sh'
end


every '10 2 * * *' do

  rake 'feed_rake:set_doctor_name'
  rake 'feed_rake:set_sector_name'
end

every '0 15 5,15,25 * *' do
  command 'cd ~/cronscript/doctors/ && ~/cronscript/doctors/query.sh'
end


# every '10 3 * * *' do
#   rake 'mse_rake:feel_old_card'
# end




#Каждые 3 часа с 6 до 18 обновляем отчет по выписанным рецептам БОЛЬШЕ НЕ ДЕЛАЕМ. АВТООБНОВЛЕНИЕ ПРИ ЗАХОДЕ НА СТРАНИЦУ
# every '0 8,9,10,12,15,16,17 * * *' do
#   rake 'feed_rake:feel_statistic_feed_from_status_age'
# end

# every '05 13 * * *'  do
#   rake 'fifa_rake:send_report'
# end

