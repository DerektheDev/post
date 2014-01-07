class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def url_without_locale_params(url)
  #   uri = URI url
  #   params = Rack::Utils.parse_query uri.query
  #   params.delete 'locale'
  #   uri.query = params.to_param.blank? ? nil : params.to_param
  #   uri.to_s
  # end

  def strip_query(url)
    url[/[^?]+/]
  end
  helper_method :strip_query

  # def retrieve_remote_screen
  #   # http://stackoverflow.com/questions/8218501/how-to-take-screenshot-of-a-website-with-rails-3-1-without-using-a-service
  #   # require 'selenium-webdriver'
  #   width = 640
  #   height = 480
  #   driver = Selenium::WebDriver.for :firefox
  #   driver.navigate.to 'http://myspace.com'
  #   driver.execute_script %Q{
  #     window.resizeTo(#{width}, #{height});
  #   }
  #   driver.save_screenshot('/tmp/screenshot.png')
  #   driver.quit
  # end

end
