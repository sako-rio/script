class Chrome
  def get_button(wait, driver, id)
    button = wait.until { driver.find_element(id: id) }
    if button.nil?
      button = false
    end
    button
  end

  #  商品選択処理
  def click_item(articles, order_information)
    img = true
    articles.each_with_index do |article, i|
      img = article.find_element(:class => 'inner-article').find_element(:tag_name => 'a').find_element(:tag_name => 'img')
      img_name = img.attribute('alt')
      if img_name == order_information['画像名']
        img.click
        break
      end
      img = false
    end
    return img
  end

  def access_website(driver)
    driver.manage.timeouts.implicit_wait = 1000
    driver.navigate.to $URL
  end

  def start(order_information, driver)
    def end_selenium(msg)
      puts msg
      loop do
      end
    end

    #  リトライ
    begin
      access_website(driver)
    rescue
      access_website(driver)
    end
    driver.manage.timeouts.implicit_wait = 1

    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 1000)
      container = nil

      #  購入ページ取得
      begin
        container = wait.until { driver.find_element(:id => 'container') }
      rescue
        execution_process = false
        loop do
          access_website(driver)
          loop do
            container = wait.until { driver.find_element(:id => 'container') }
            execution_process = true unless container.nil?
            break
          end
          break
        end
      end

      articles = wait.until { container.find_elements(tag_name: 'article') }
      if articles.empty?
        execution_process = false
        loop do
          articles = wait.until { container.find_elements(tag_name: 'article') }
          break unless articles.empty?
        end
      end

      unless click_item(articles, order_information)
        loop do
          break unless click_item(articles, order_information)
        end
      end

      button = get_button(wait, driver, 'add-remove-buttons')
      unless button.nil?
        loop do
          button = get_button(wait, driver, 'add-remove-buttons')
          unless button.nil?
            break
          end
        end
      end

      target = wait.until { button.find_element(name: 'commit') }

      unless target.nil?
        loop do
          target = wait.until { button.find_element(name: 'commit') }
          unless target.nil?
            break
          end
        end
      end


      target.click

      cart = get_button(wait, driver, 'cart')
      unless cart.nil?
        loop do
          cart = get_button(wait, driver, 'cart')
          unless cart.nil?
            break
          end
        end
      end

      target = wait.until { cart.find_element(class: 'checkout') }
      unless target.nil?
        loop do
          target = wait.until { cart.find_element(class: 'checkout') }
          unless target.nil?
            break
          end
        end
      end

      target.click

      cart_body = wait.until { driver.find_element(id: 'cart-body') }
      unless cart_body.nil?
        loop do
          cart_body = wait.until { driver.find_element(id: 'cart-body') }
          unless cart_body.nil?
            break
          end
        end
      end

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

      driver.save_screenshot('/Users/sako/Desktop/filename.png')

      end_selenium('BOT処理終了。購入手続きを手動で続けて下さい。')
    rescue
      end_selenium('システムエラー　この先の処理は手動で行って下さい。')
    end
  end
end
