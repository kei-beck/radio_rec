# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
job_type :rbenv_bundle_runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && rbenv exec rails runner ':task' :output"
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

# ラジオ録音
set :output, {:error => 'log/error_RadioRecController.log', :standard => 'log/cron_RadioRecController.log'}
every 1.minute do
  rbenv_bundle_runner "Tasks::RadioRecController.new.execute"
end

# 予約情報登録(日次)
set :output, {:error => 'log/error_ReservationRegister.log', :standard => 'log/cron_ReservationRegister.log'}
every :day, :at => '7:10 am' do
  rbenv_bundle_runner "Tasks::ReservationRegister.new.execute"
end

# radiru 番組表取込(日次)
set :output, {:error => 'log/error_RadiruProgramImport.log', :standard => 'log/cron_RadiruProgramImport.log'}
every :day, :at => '7:05 am' do
  rbenv_bundle_runner "Tasks::RadiruProgramImport.new.execute"
end

# radiko 番組表取込(日次)
set :output, {:error => 'log/error_RadikoProgramImportDaily.log', :standard => 'log/cron_RadikoProgramImportDaily.log'}
every :day, :at => '7:00 am' do
  rbenv_bundle_runner "Tasks::RadikoProgramImportDaily.new.execute"
end

# radiko 番組表取込(週次)
set :output, {:error => 'log/error_RadikoProgramImportWeekly.log', :standard => 'log/cron_RadikoProgramImportWeekly.log'}
every :monday, :at => '10:00 am' do
  rbenv_bundle_runner "Tasks::RadikoProgramImportWeekly.new.execute"
end

# radiko 放送局取込(週次)
set :output, {:error => 'log/error_RadikoStationImport.log', :standard => 'log/cron_RadikoStationImport.log'}
every :monday, :at => '9:55 am' do
  rbenv_bundle_runner "Tasks::RadikoStationImport.new.execute"
end

# radio系テーブル整理
set :output, {:error => 'log/error_TableOrganize.log', :standard => 'log/cron_TableOrganize.log'}
every :monday, :at => '0:00 am' do
  rbenv_bundle_runner "Tasks::TableOrganize.new.execute"
end

# $ su -
# $ cd /usr/local/VMWorks/rails/radio_rec/
# $ bundle exec whenever --update-cron