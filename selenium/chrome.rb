class Chrome
  require 'selenium-webdriver'

  def start(order_information)
    begin
      #  アクセス処理
      driver = Selenium::WebDriver.for :chrome
      wait = Selenium::WebDriver::Wait.new(timeout: 5)
      driver.manage.timeouts.implicit_wait = 1
      driver.navigate.to $URL
      container = driver.find_element(:id => 'container')
      articles = container.find_elements(:tag_name => 'article')
      target_item = ''
      articles.each_with_index do |article, i|
        img = article.find_element(:class => 'inner-article').find_element(:tag_name => 'a').find_element(:tag_name => 'img')
        img_name = img.attribute("src").split('/').last
        if img_name == order_information['画像名']
          target_item = img
          break
        end
      end
      sleep 1
      target_item.click

      details = driver.find_element(:id => 'details')
      item_details = details.find_elements(:class => 'styles')[0].find_elements(:tag_name => 'li')
      target_item = ''
      item_details.each do |item|
        target = item.find_element(:tag_name => 'a')
        target_color = target.attribute("data-style-name")
        if target_color == order_information['色']
          target_item = target
          break
        end
      end
      sleep 1
      target_item.click

      sleep 1
      driver.find_element(:id => 'add-remove-buttons').find_element(:name => 'commit').click

      sleep 1
      driver.find_element(:id => 'cart').find_element(:class => 'checkout').click

      sleep 1
      cart_body = driver.find_element(:id => 'cart-body')

      #  姓
      cart_body.find_element(:id => 'credit_card_last_name').send_keys(order_information['姓'])

      #  名
      cart_body.find_element(:id => 'credit_card_first_name').send_keys(order_information['名'])

      # メール
      cart_body.find_element(:id => 'order_email').send_keys(order_information['Eメール'])

      # 電話番号
      cart_body.find_element(:id => 'order_tel').send_keys(order_information['電話番号'])

      #  都道府県
      select = Selenium::WebDriver::Support::Select.new(cart_body.find_element(:id => 'order_billing_state'))
      select.select_by(:text, order_information['都道府県'])

      # 市区町村
      cart_body.find_element(:id => 'order_billing_city').send_keys(order_information['市区町村'])

      # 住所
      cart_body.find_element(:id => 'order_billing_address').send_keys(order_information['住所'])

      # 郵便番号
      cart_body.find_element(:id => 'order_billing_zip').send_keys(order_information['郵便番号'])

      # 支払い方法
      select = Selenium::WebDriver::Support::Select.new(cart_body.find_element(:id => 'credit_card_type'))
      select.select_by(:text, order_information['支払方法'])

      # カード番号
      cart_body.find_element(:id => 'cnb').send_keys(order_information['カード番号'])

      # 有効期限月 セレクトボックス
      select = Selenium::WebDriver::Support::Select.new(cart_body.find_element(:id => 'credit_card_month'))
      select.select_by(:text, order_information['有効期限(月)'])

      # 有効期限年 セレクトボックス
      select = Selenium::WebDriver::Support::Select.new(cart_body.find_element(:id => 'credit_card_year'))
      select.select_by(:index, order_information['有効期限(年)'])

      # cvv番号
      cart_body.find_element(:id => 'vval').send_keys(order_information['CVV番号'])

      # 規約同意
      cart_body.find_element(:id => 'order_terms').click

      # 購入
      driver.find_element(:id => 'cart-footer').find_element(:name => 'commit').click

      sleep 5
      driver.quit
    rescue
      puts "システムエラー　この先の処理は手動で行って下さい"
      loop do
      end
    end
  end
end
