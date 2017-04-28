require './constant.rb'
require './excelx.rb'
require './chrome.rb'
require './firefox.rb'
require 'date'

def timer(arg, &proc)
  x = case arg
  when Numeric then arg
  when Time    then arg - Time.now
  when String  then Time.parse(arg) - Time.now
  else raise   end

  sleep x if block_given?
  yield
end

excelx = Excelx.new()
order_information = excelx.purse()

timer(order_information['開始時間']) do
  chrome = Chrome.new()
  chrome.start(order_information)
end
