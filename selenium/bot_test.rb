require 'bundler'
Bundler.require
require './constant.rb'
require './excelx.rb'
require './chrome.rb'

excelx = Excelx.new()
order_information = excelx.purse()

if order_information['ブラウザ'] == 'firefox'
  firefox = Firefox.new()
  firefox.start()
else
  chrome = Chrome.new()
  chrome.start(order_information)
end
