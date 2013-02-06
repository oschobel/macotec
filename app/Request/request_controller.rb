require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'time'
require 'date'

class RequestController < Rho::RhoController
  include BrowserHelper
 # @layout = 'custom_layout'
 
  $saved = nil
  $saved_value = nil
  $choosed = {}
  
  SERVICE_HOST = Rho::RhoConfig.request_server_url
  #############################################################################
  def request
    @products = Product.get_categories
    $choosed['1'] = nil
    render :action => :request
  end
  
  
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

  
  ##############################################################################
  
  
  def submit
    @data = "subject=Mietanfrage aus Maco-Tec App&product=#{@params['product']}&rental_begin=#{@params['rental_begin']}&operation_period=#{@params['operation_period']}&amount_product=#{@params['amount_product']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&information=#{@params['information']}"    
    
    Rho::AsyncHttp.post(:url => SERVICE_HOST, 
                        :headers => {"Content-Type" => "application/x-www-form-urlencoded","charset" => "UTF-8"}, 
                        :body => @data, 
                        :callback => url_for(:action => :http_callback),
                        :callback_param => "")
    WebView.execute_js('setFieldValue("date","");')
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
  
  def http_callback
    sleep 4
    if @params["body"] == "SUCCESS"
       WebView.navigate  url_for :action => :submit_success  
    elsif @params["body"] == "FAILED"
      WebView.navigate url_for :action => :submit_failed
    else
      WebView.navigate url_for :action => :submit_wrong_data
    end
  end
  
  def after_submit
    
  end
end