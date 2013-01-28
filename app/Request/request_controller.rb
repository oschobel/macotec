require 'rho/rhocontroller'
require 'helpers/browser_helper'
# require 'time'
# require 'date'

class RequestController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  
  def request
    @products = Product.get_categories
    render :action => :request, :layout => 'custom_layout'
  end
  
end