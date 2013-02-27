require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'time'
require 'date'
require 'json'
require 'Connection/connection_controller'

class RequestController < Rho::RhoController
  include BrowserHelper
 # @layout = 'custom_layout'
 
  $saved = nil
  $saved_value = nil
  $choosed = {}
  
  SERVICE_HOST_REQUEST_RENTAL = Rho::RhoConfig.request_rental_server_url
  SERVICE_HOST_REQUEST_PROJECT = Rho::RhoConfig.request_project_server_url 
  APP_VERSION_KEY = Rho::RhoConfig.app_version_key
  
  def request
    
  end
  
  def request_project
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
  end
  
  def request_rental
    @products = Product.get_categories
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
   
    #reset date. otherwise it's being shown all the time, once it's been set 
    $choosed['1'] = nil
    
    render :action => :request_rental
  end
  
  ##################################### Begin DateTimePicker ########################################
  
  def callback_alert
    Alert.show_popup( :message => "Wollen Sie wirklich abbrechen?\n\n Ihre Eingaben gehen dabei verloren.", :icon => :alert,
      :buttons => ["Ok", "Cancel"], :callback => url_for(:action => :popup_callback) )
  end

  def popup_callback
    id = @params['button_id']
    title = @params['button_title']
    puts "popup_callback: id: '#{id}', title: '#{title}'"
    WebView.navigate '/app' if title.downcase() == 'ok'
  end
  
  
  def popup
    flag = @params['flag']
    if ['0', '1', '2'].include?(flag)
      ttt = $choosed[flag]
      if ttt.nil?
        preset_time = Time.new
      else
        preset_time = Time.parse(ttt)  
      end

      if flag == '1'
          DateTimePicker.set_change_value_callback url_for(:action => :callback)
          current_value = Time.at(preset_time).strftime('%F')
          WebView.execute_js('setFieldValue("date","'+current_value+'");')
          $saved_value = $choosed[flag]
          if $saved_value.nil?
              $saved_value = ''
          end
      end 
      DateTimePicker.choose url_for(:action => :callback), @params['title'], preset_time, flag.to_i, Marshal.dump({:flag => flag, :field_key => @params['field_key']})
    end
    
    render :string => '', :back => 'callback:' + url_for(:action => :callback_alert)
   
  end
 
  def callback
    if @params['status'] == 'ok'
        $saved = nil
        datetime_vars = Marshal.load(@params['opaque'])
        format = case datetime_vars[:flag]
            when "0" then '%d. %B %Y %T'
            when "1" then '%d. %B %Y'
            when "2" then '%T'
            else '%F %T'
        end
        formatted_result = Time.at(@params['result'].to_i).strftime(format)
        $choosed[datetime_vars[:flag]] = formatted_result
        WebView.execute_js('setFieldValue("'+datetime_vars[:field_key]+'","'+formatted_result+'");')
    end
    if @params['status'] == 'cancel'
        datetime_vars = Marshal.load(@params['opaque'])
        if datetime_vars[:flag] == '1'
            WebView.execute_js('setFieldValue("'+datetime_vars[:field_key]+'","'+$saved_value+'");')
        end
    end
    if @params['status'] == 'change'
       datetime_vars = Marshal.load(@params['opaque'])
        if datetime_vars[:flag] == '1'
           formatted_result = Time.at(@params['result'].to_i).strftime('%F')
           WebView.execute_js('setFieldValue("date","'+formatted_result+'");')
       end
   end
 
 end

  
  ##################################### End DateTimePicker ########################################
  
  
  def submit_request_project
    @data = "subject=Anfrage zu Projekt aus Maco-Tec App&project_number=#{@params['project_number']}&information=#{@params['information']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}"
    ConnectionController.service_request("send_request_project_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    
    render :action => :wait
  end
  
  def submit_request_rental
    @data = "subject=Mietanfrage aus Maco-Tec App&product=#{@params['product']}&rental_begin=#{@params['rental_begin']}&operation_period=#{@params['operation_period']}&amount_product=#{@params['amount_product']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&information=#{@params['information']}"    
    ConnectionController.service_request("send_request_rental_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    
    render :action => :wait
  end
  
  def submit_success
     render :action => :submit_success, :back => '/app'
  end
  
  def submit_failed
     render :action => :submit_failed, :back => '/app'
  end
  
  def submit_wrong_data
    render :action => :submit_wrong_data, :back => '/app'
  end
  
  def submit_not_supported
    render :action => :submit_not_supported, :back => '/app'
  end
  
  def message_to_user
    render :action => :message_to_user, :back => '/app'
  end
  
  def http_callback
    sleep 4
    if @params["status"] == "error"
      @answer_backend = '{"message"=>"Es gibt ein Problem. Wir arbeiten an einer Lösung dafür. Bitte versuchen Sie es später noch einmal."}'
      WebView.navigate url_for :action => :message_to_user, :query => @answer_backend
    end
    
    begin
      @answer_backend = Rho::JSON.parse(@params["body"])  
      
      if @answer_backend["result"] == "SUCCESS"
         WebView.navigate  url_for :action => :submit_success, :query => @answer_backend
      elsif @answer_backend["result"] == "FAILED"
        WebView.navigate url_for :action => :submit_failed, :query => @answer_backend
      elsif @answer_backend["result"] == "NOT_SUPPORTED_VERSION"
        WebView.navigate url_for :action => :submit_not_supported, :query => @answer_backend
      elsif @answer_backend["result"] == "ERROR"
        WebView.navigate url_for :action => :submit_wrong_data, :query => @answer_backend
      elsif @answer_backend["result"] == "MESSAGE_TO_USER"
        WebView.navigate url_for :action => :message_to_user, :query => @answer_backend
      else
        @answer_backend = '{"message"=>"Der Server ist nicht erreichbar. Bitte prüfen Sie Ihre Internetverbindung oder versuchen Sie es später noch einmal."}'
        WebView.navigate url_for :action => :message_to_user, :query => @answer_backend
      end
    rescue Exception => msg
      @answer_backend = '{"message"=>"Es gibt ein Problem. Wir arbeiten an einer Lösung dafür. Bitte versuchen Sie es später noch einmal."}'
      WebView.navigate url_for :action => :message_to_user, :query => @answer_backend
    end
  end
  
    def get_image_uri
    #@image = Image.first
    puts "############################# #{Image.first.image_uri}"
    return Image.first.image_uri
  end
end