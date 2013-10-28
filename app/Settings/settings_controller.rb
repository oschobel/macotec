require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class SettingsController < Rho::RhoController
  include BrowserHelper
  
  # Renders the index view even without saying so. Default behavious of Rhodes.
  def index
    
  end
  
  # Saves user data in the Settings model
  def save_data
    Settings.removeSavedData
    @data = Settings.create({"company" => @params['company'], "phone" => @params['phone'], "email" => @params['email']})
    Alert.show_popup( :message => Localization::System[:saved_data], 
                      :title => "",
                      :buttons => ["OK"], 
                      :callback => url_for(:action => :save_data_callback) )
  end
  
  # This callback method navigates user to request page after successfully updating user data
  def save_data_callback
    WebView.navigate url_for(:controller => :Request, :action => :request)
  end
  
  # This method retrieves the data from the Settings model and updates the field in the current view
  def get_data
    @data = Settings.getSavedData
    WebView.execute_js('setData("'+@data.company+'","'+@data.phone+'","'+@data.email+'");')
  end
  
  def has_user_data
    @data = Settings.getSavedData
    if @data
      render :string => "true".to_json
    end
    render :string => "false".to_json
  end
  
  def get_user_data
    @data = Settings.getSavedData
    return @data
  end

end
