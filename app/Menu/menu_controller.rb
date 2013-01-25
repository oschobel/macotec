require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MenuController < Rho::RhoController
  include BrowserHelper
  include Product
  @layout = 'custom_layout'
  
  
  def contact
     render :action => :contact, :layout => 'custom_layout'
  end
  
  def info
     render :action => :info, :layout => 'custom_layout'
  end
  
  def request
     render :action => :request, :layout => 'custom_layout'
  end
  
  def products
     render :action => :info, :layout => 'custom_layout'
  end
  
  
end