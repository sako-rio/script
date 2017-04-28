require './constant.rb'
require './excelx.rb'
require './chrome.rb'
require './firefox.rb'
require 'date'

excelx = Excelx.new()
order_information = excelx.purse()
time_now = Time.now
date_time = order_information['開始時間'].split('/')
time = date_time.last.split(':')
local_time = Time.new(date_time[0].to_i, date_time[1].to_i, date_time[2].to_i, time[0].to_i, time[1].to_i, time[2].to_i, "+09:00")
# loop do
#   break if local_time == time_now
# end
chrome = Chrome.new()
chrome.start(order_information)
