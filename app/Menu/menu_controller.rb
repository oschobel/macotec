require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MenuController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  
  def contact
     render :action => :contact, :back => '/app'
  end
  
  def info
     render :action => :info, :back => '/app'
  end
  
end