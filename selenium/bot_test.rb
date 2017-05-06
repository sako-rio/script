require 'bundler'
Bundler.require
require './constant.rb'
require './excelx.rb'
require './chrome.rb'

excelx = Excelx.new()
order_information = excelx.purse()
chrome = Chrome.new()
chrome.start(order_information)
