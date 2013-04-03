require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class MenuController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  
  
  def contact 
     render :action => :contact, :back => '/app'
  end
  
  def info
    Device.instance
    render :action => :info, :back => '/app'
  end
  
  def locations
    show_map
  end
  
  def show_map
    # Build up the parameters for the call
    map_params = {
          # General settings for the map, type, viewable area, zoom, scrolling etc.
          # We center on the user, with 0.2 degrees view
      :settings => {:map_type => "standard",:region => {:center => "”, “50.828301,10.172119", :radius => ""},
                    :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                    :api_key => '0U1BIcKeOsOD8K_evPOtEMHFOzMN3CJXlOg23HA'},
    
            # This annotation shows the user, give the marker a title, and a link directly to that user
      :annotations => [{
                         :latitude => 52.520924, 
                         :longitude => 13.357205, 
                         :title => "MacoTec Berlin", 
                         :subtitle => "",
                         :url => url_for(url_for :controller => :Menu, :action => :contact)
                      }]
                   }
  
  # This call displays the map on top of the entire screen
    MapView.create map_params
  
      # After the user closes the map, they will be shown with whatever you redirect or render here.
    redirect url_for :controller => :Menu, :action => :contact
  end
end