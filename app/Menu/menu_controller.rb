require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MenuController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  
  def contact
     render :action => :contact, :layout => 'custom_layout', :back => '/app'
  end
  
  def info
     render :action => :info, :layout => 'custom_layout', :back => '/app'
  end
  
  def products
     render :action => :info, :layout => 'custom_layout', :back => '/app'
  end
  
  
end