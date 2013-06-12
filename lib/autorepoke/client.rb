require 'selenium-webdriver'

module Autorepoke

  class Client
    def initalize(username,password, ids)

      @ids = ids

      @driver = Selenium::WebDriver.for :firefox
      @driver.timeout = 180

      @driver.navigate.to "https://www.facebook.com/pokes"

      element = @driver.find_element(:name =>"email");
      element.send_keys(username)

      element = @driver.find_element(:name =>"pass");
      element.send_keys(password)

      element.submit

      return
    end

    def start

      lastpoke = Time.now

      while true
        @driver.navigate.to "https://www.facebook.com/pokes?#{rand(20000)}"
        sleep 10
        @ids.each do |id|
          if poke(id)
            lastpoke = Time.now

            if block_given?
              yield id
            end
          end
        end
      end
    end

  private
    def poker(uid)
      begin
        element = @driver.find_element(:xpath =>"//a[@ajaxify='/ajax/pokes/poke_inline.php?uid=#{uid}&pokeback=1']")
        element.click
        puts "#{Time.now} -- #{uid} POKED!"
        return true

      rescue
        return false
      end
    end

end
