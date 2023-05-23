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

# REFACTOR invoke directly DailyRankingDigestService
# left as an example tests
every 1.day, at: '4:30 am' do
  runner "DailyRankingDigestJob.perform"
end

#  I'm too lazy to write another service
every :reboot do
  rake "ts:start"
end
