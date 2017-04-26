require './constant.rb'
require './excelx.rb'
require './chrome.rb'
require './firefox.rb'

excelx = Excelx.new()
order_information = excelx.purse()
chrome = Chrome.new()
chrome.start(order_information)
