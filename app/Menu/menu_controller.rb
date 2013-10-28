require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

# This class contains methods which render certain views as well as a map

class MenuController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
   GOOGLE_MAPS_API_KEY = Rho::RhoConfig.google_maps_api_key
  
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
    map_params = {
      :settings => {:map_type => "standard",:region => {:center => "”, “50.828301,10.172119", :radius => ""},
                    :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                    :api_key => GOOGLE_MAPS_API_KEY},
    
      :annotations => [{
                         :latitude => 52.520924, 
                         :longitude => 13.357205, 
                         :title => "MacoTec Berlin", 
                         :subtitle => "",
                         # :url => url_for(url_for :controller => :Menu, :action => :contact)
                      },
                      {
                         :latitude => 50.946362, 
                         :longitude => 6.941586, 
                         :title => "MacoTec Köln", 
                         :subtitle => "",
                         # :url => url_for(url_for :controller => :Menu, :action => :contact)
                      },
                      {
                         :latitude => 49.755566, 
                         :longitude => 6.638572, 
                         :title => "MacoTec Trier", 
                         :subtitle => "",
                         # :url => url_for(url_for :controller => :Menu, :action => :contact)
                      }
                      ]
                   }
    MapView.create map_params
    redirect url_for :controller => :Menu, :action => :contact
  end
end