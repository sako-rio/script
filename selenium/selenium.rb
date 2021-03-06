require 'bundler'
Bundler.require
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
if order_information['ブラウザ'] == 'firefox'
  timer(order_information['開始時間']) do
    firefox = Firefox.new()
    firefox.start()
  end
else
  timer(order_information['開始時間']) do
    driver = Selenium::WebDriver.for :chrome
    chrome = Chrome.new()
    chrome.start(order_information, driver)
  end
end
