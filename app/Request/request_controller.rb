require 'rho/rhocontroller'
require 'helpers/browser_helper'
# require 'time'
# require 'date'

class RequestController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  SERVICE_HOST = Rho::RhoConfig.request_server_url
  
  
  def request
    @products = Product.get_categories
    render :action => :request, :layout => 'custom_layout'
  end
  
  def submit
    @data = "subject=Mietanfrage aus Maco-Tec App&product=#{@params['product']}&rental_begin=#{@params['rental_begin']}&operation_period=#{@params['opertaion_period']}&amount_product=#{@params['amount_product']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&information=#{@params['information']}"    
    
    @response = Rho::AsyncHttp.post(:url => SERVICE_HOST, 
                        :headers => {"Content-Type" => "application/x-www-form-urlencoded","charset" => "UTF-8"}, 
                        :body => @data, 
                        :callback => url_for(:action => :after_submit),
                        :callback_param => "post=complete")
    render :after_submit                  
  end
  
  def after_submit
    
  end
end