require 'selenium-webdriver'
require 'headless'
require 'logger'

module Autorepoke

  class Client
    def initialize(username,password, ids)

      @log = Logger.new("logging.txt", File::WRONLY | File::APPEND);
      @log.info("Loaded client for ids #{ids}")

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
      return
    end

    def start
      lastpoke = Time.now
      @log.info("starting up")

      while true
        @log.debug("start iteration")

        @driver.navigate.to "https://www.facebook.com/pokes?#{rand(20000)}"

        @log.debug("successfully loaded page")
        sleep 10
        @ids.each do |id|
          @log.debug("trying #{id}")
          if poker(id)
            lastpoke = Time.now
            @log.info("hit for #{id}")

            if block_given?
              yield id
            end
            @log.debug("succesffully run subblock")
          end
        end
        @log.debug("finished iterations"
        sleep 30 + rand(100)
        sleep 60 + rand(1200) if Time.now - lastpoke > 1000
        sleep 60 + rand(1200) if Time.now - lastpoke > 10000
      end
    end

  private
    def poker(uid)
      begin
        if @driver.find_elements(:xpath =>"//a[@ajaxify='/ajax/pokes/poke_inline.php?uid=#{uid}&pokeback=1']").size > 0
          element = @driver.find_element(:xpath =>"//a[@ajaxify='/ajax/pokes/poke_inline.php?uid=#{uid}&pokeback=1']")
          element.click
          return true
        else
          return false
        end


      rescue
        @log.error("error finding button to press! #{$!}")
        return false
      end
    end
  end

end
