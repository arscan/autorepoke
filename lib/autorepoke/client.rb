require 'selenium-webdriver'
require 'headless'

module Autorepoke

  class Client
    def initialize(username,password, ids)

      @ids = ids

      headless = Headless.new
      headless.start

      @driver = Selenium::WebDriver.for :firefox
      #@driver.timeout = 180

      @driver.navigate.to "https://www.facebook.com/pokes"
      sleep(1)

      element = @driver.find_element(:name =>"email");
      element.send_keys(username)
      sleep(1)

      element = @driver.find_element(:name =>"pass");
      element.send_keys(password)

      element.submit

      sleep(5)
      puts @driver.title

      return
    end

    def start
      puts "starting up"

      lastpoke = Time.now

      while true
        puts "going about it"
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
        if @driver.find_element(:xpath =>"//a[@ajaxify='/ajax/pokes/poke_inline.php?uid=#{uid}&pokeback=1']").size > 0
          puts "found them!"
          element = @driver.find_element(:xpath =>"//a[@ajaxify='/ajax/pokes/poke_inline.php?uid=#{uid}&pokeback=1']")
          element.click
          puts "#{Time.now} -- #{uid} POKED!"
          return true
        else
          puts "didn't found them!"
          return false
        end


      rescue
        return false
      end
    end
  end

end
