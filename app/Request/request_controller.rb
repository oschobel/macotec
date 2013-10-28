require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/application_helper'
require 'time'
require 'date'
require 'json'
require 'Connection/connection_controller'

class RequestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper
  
 # @layout = 'custom_layout'
 
  $saved = nil
  $saved_value = nil
  $choosed = {}
  
  @@geo_callback_counter = 0
  @@geo_data_accuracy = 1000
  @@geo_latitude = 0
  @@geo_longitue = 0
  @@last_geolocation_update = nil
  
  
  SERVICE_HOST_REQUEST_RENTAL = Rho::RhoConfig.request_rental_server_url
  SERVICE_HOST_REQUEST_PROJECT = Rho::RhoConfig.request_project_server_url 
  GOOGLE_GEO_API_JSON = Rho::RhoConfig.google_json_geo_api
  GOOGLE_MAPS_API_KEY = Rho::RhoConfig.google_maps_api_key
  SCREEN_WIDTH = System.get_property('real_screen_width')
  
  
  def missing_fields
    show_popup_message(Localization::Request[:contact_details_popup], "",['OK'], "")
  end
  
  def check_network
    if !System.get_property('has_network')
      show_popup_message(Localization::Request[:no_network], "",['OK'], "")      
    end
  end
  
  def get_map
    get_geolocation("map")
  end
  
  def get_location
    get_geolocation("location")
  end
  
  # Callback method to trigger gps in order to get most accurate position data
  def geo_preparation_callback
    @@geo_callback_counter += 1
    if @@geo_callback_counter >= 10
      GeoLocation.turnoff
      @@last_geolocation_update = Time.now
      @@geo_callback_counter = 0
    end
  end
  
  # This method opens the google map on android devices and shows your current position
  def show_map(lat, long, path)
    map_params = {
    :settings => {:map_type => "standard",:region => [lat, long, 0.2, 0.2],
                  :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                  :api_key => GOOGLE_MAPS_API_KEY},
  
    :annotations => [{
                       :latitude => lat, 
                       :longitude => long, 
                       :title => Localization::Request[:address], 
                       :subtitle => "I am here",
                       :url => url_for(:action => :request_rental)
                    }]
  }
    MapView.create map_params
    WebView.navigate url_for :action => :request
  end
  
  # This method gets called when the user presses the button to find his location. It basically checks if the GeoLocation system is up and running and then retrieves the data
  def get_geolocation(action)
    if GeoLocation.known_position?
      show_popup_message(Localization::Request[:address_lookup], Localization::Request[:address],['Cancel'], url_for(:action => :geo_popup_callback)) if action == "location"
      GeoLocation.set_notification( url_for(:action => :geo_location_callback), "action=#{action}", 0)
    else
      show_popup_message(Localization::Request[:no_gps], "Adresse",['Retry','Cancel'], url_for(:action => :geo_popup_callback))
    end
  end
  
  def geo_popup_callback
    if @params['button_id'] == 'Retry'
      Alert.hide_popup
      get_geolocation("location")
    end
  end
  
  # Callback method that runs 5 times and keeps the geodata with the smallest value for accuracy. This geodata is being sent to googlemaps to resolve it into a human readable address
  def geo_location_callback
    @@geo_callback_counter += 1
    if @params['accuracy'].to_i < @@geo_data_accuracy
      @@geo_data_accuracy = @params['accuracy'].to_i 
      @@geo_latitude = @params['latitude'].to_f
      @@geo_longitue = @params['longitude'].to_f
    end 
    
    if @@geo_callback_counter >= 5
      GeoLocation.turnoff
      @@geo_callback_counter = 0
      if @params['action'] == "map"
        show_map(@@geo_latitude, @@geo_longitue,"") 
        Alert.hide_popup  
      elsif @params['action'] == "location"
        url = get_url_for_google_reverse_geocoding(@@geo_latitude, @@geo_longitue)
        Rho::AsyncHttp.get(
              :url => url,
              :callback => (url_for :action => :httpget_geo_callback),
              :callback_param => "accuracy=#{@@geo_data_accuracy}"
      )
      end
      @@geo_data_accuracy = 1000
      @@last_geolocation_update = Time.now.to_i
    end
  end
  
  # The callback method that processes the data received from googlemaps
  def httpget_geo_callback
    if @params['body']['results'] && @params['body']['results'].length > 0
      address =  @params['body']['results'][0]['formatted_address'] 
      accuracy = @params['accuracy'].to_i.to_s
      WebView.execute_js('setFieldValue("location","'+address+' \n('+Localization::Request[:accuracy]+' = '+accuracy+' '+Localization::Request[:meter]+')");')
      Alert.hide_popup    
    elsif @params['body']['status']
      WebView.execute_js('setFieldValue("location","'+@params['body']['status']+'   accuracy = '+@params['accuracy']+'");')
      Alert.hide_popup    
    else
      WebView.execute_js('setFieldValue("location","'+@params['body'].to_s+'");')
      Alert.hide_popup    
    end
  end

  # This method processes the status-message sent by the backend after a transaction has been initiated by the app.
  def process_submit_result
    if @params["result"]
      case @params["result"]
      when "SUCCESS"
        @message = Localization::Message[:send_request_success]
        @icon = "/public/images/macotec/success.png"
        @title = "SUCCESS"
        @button = ["OK"]
      when "FAILED"
        @message = Localization::Message[:send_request_no_success]
        @title = "FAILED"
        @button = ["Contact MacoTec","Cancel"]
      when "NOT_SUPPORTED_VERSION"
        @message = @params["message"]
        @title = "NOT SUPPORTED"
        @button = ["Contact MacoTec","Cancel"]
      when "ERROR"
        if (@params["message"]) && (@params["message"].include? "Email")
          @message = @params["message"]
          @title = "ERROR"
          @button = ["Contact MacoTec","Cancel"]
        else
          @message = Localization::Message[:problem]
          @button = ["Contact MacoTec","Cancel"]
        end
      when "MESSAGE_TO_USER" 
        @message = @params["message"]
        @title = "MESSAGE"
        @button = ["Contact MacoTec","Cancel"]
      else
        @message = '{"message"=>"Der Server ist nicht erreichbar. Bitte prüfen Sie Ihre Internetverbindung oder versuchen Sie es später noch einmal."}'
        @title = "MESSAGE"   
        @button = ["Contact MacoTec","Cancel"]
      end
        
      Alert.show_popup( :message => @message, 
                        :title => @title,
                        :icon => @icon,
                        :buttons => @button,
                        :callback => url_for(:action => :request_popup_callback))
    end
    WebView.navigate Rho::RhoConfig.start_path
  end
  
  # This method renders the Services overview page. Also starts triggering the GeoLocation API to assure greater accuracy of position.
  # If the app has been started the first time, this mehtode also downloads first time catalog data
  def request
    GeoLocation.set_notification url_for(:action => :geo_preparation_callback), "", 0
    if @params['submit_error_message']
      show_popup_message(@params['submit_error_message'], "",['OK'], "")
    end
    if Product.get_categories.length < 1
      ConnectionController.service_request("catalog_" + Device.instance.locale + ".php",nil,"get",nil,nil,url_for(:action => :http_catalog_callback),nil,nil)
    end
    render :action => :request
  end
  
  # Callback method of popup message
  def request_popup_callback
    id = @params['button_id']
    if id == "Contact MacoTec"
      WebView.navigate url_for :controller => :Menu, :action => :contact
    end
    # WebView.navigate Rho::RhoConfig.start_path
  end
  
  # This method renders the Release Notification View
  def release_notification
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
    
    #reset date. otherwise it's being shown all the time, once it's been set 
    $choosed['1'] = nil
  end
  
  # This method renders the Service Request View
  def service_request
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
  end
  
  # This method renders the Request Project View
  def request_project
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
  end
  
  # This method renders the Request from Catalog View
  def request_from_catalog
    @details_name = @params["details_name"]
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
   
    #reset date. otherwise it's being shown all the time, once it's been set 
    $choosed['1'] = nil
    
    render :action => :request_from_catalog
  end
  
  # This method renders the Request Rental View and retrieves the categories of the Product (Catalog) model
  def request_rental
    @details_name = @params["details_name"]
    @products = Product.get_categories
    if @products.length < 1
      sleep 2
      @products = Product.get_categories
    end
    @has_data = Settings.has_user_data
    @data = Settings.getSavedData
   
    #reset date. otherwise it's being shown all the time, once it's been set 
    $choosed['1'] = nil
    
    render :action => :request_rental
  end
  
  # Callback method which is being called when the catalog data has been downloaded from the backend
  def http_catalog_callback
    if @params['http_error'] == "200"
      Product.update_product_list @params['body']
      Device.instance.last_sync = Date.today
      Device.instance.save
    end
  end
  
  # This method prepares the data being send to the backend after a release request has been initiated. If an image should be sent as well, it puts the data in a mulitpart array, in a string otherwise
  def submit_request_release
    if @params['hiddenImagePath'] == ''
      @data = "subject=Freimeldung aus Maco-Tec App&product_machine=#{@params['product_machine']}&pickup_date=#{@params['pickup_date']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&additional_location_information=#{@params['additional_location_information']}&hardware_id=#{Device.instance.hardware_id}&device_os=#{Device.instance.device_os}&locale=#{Device.instance.locale}&device_os_version=#{Device.instance.device_os_version}" 
      ConnectionController.service_request("send_request_release_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    else
      multipart_array = [{:filename => @params['hiddenImagePath'], :name => "image", :content_type => "image/jpg"},
                   {:name => "hardware_id",:body => Device.instance.hardware_id},
                   {:name => "device_os",:body => Device.instance.device_os},
                   {:name => "locale",:body => Device.instance.locale},
                   {:name => "device_os_version",:body => Device.instance.device_os_version},
                   {:name => "action",:body => "submit_request_release"},
                   {:name => "subject",:body => "Freimeldung aus Maco-Tec App"},
                   {:name => "product_machine", :body => @params['product_machine']},
                   {:name => "pickup_date", :body => @params['pickup_date']},
                   {:name => "location", :body => @params['location']},
                   {:name => "company", :body => @params['company']},
                   {:name => "phone", :body => @params['phone']},
                   {:name => "email", :body => @params['email']},
                   {:name => "additional_location_information", :body => @params['additional_location_information']},
                  ]
      ConnectionController.service_request("send_request_release_test.php",nil,"upload_file",nil, nil, url_for(:action => :http_callback), nil, multipart_array)
    end
    render :action => :wait
  end
  
    # This method prepares the data being send to the backend after a service request has been initiated. If an image should be sent as well, it puts the data in a mulitpart array, in a string otherwise
  def submit_request_service
     if @params['hiddenImagePath'] == ''
      @data = "subject=Schadensmeldung aus Maco-Tec App&project_number=#{@params['damage_nature']}&information=#{@params['damage_description']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&hardware_id=#{Device.instance.hardware_id}&device_os=#{Device.instance.device_os}&locale=#{Device.instance.locale}&device_os_version=#{Device.instance.device_os_version}"
      ConnectionController.service_request("send_request_service_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    else
      multipart_array = [{:filename => @params['hiddenImagePath'], :name => "image", :content_type => "image/jpg"},
                   {:name => "hardware_id",:body => Device.instance.hardware_id},
                   {:name => "device_os",:body => Device.instance.device_os},
                   {:name => "locale",:body => Device.instance.locale},
                   {:name => "device_os_version",:body => Device.instance.device_os_version},
                   {:name => "action",:body => "submit_request_project"},
                   {:name => "subject",:body => "Schadensmeldung aus Maco-Tec App"},
                   {:name => "damage_nature", :body => @params['damage_nature']},
                   {:name => "damage_description", :body => @params['damage_description']},
                   {:name => "company", :body => @params['company']},
                   {:name => "phone", :body => @params['phone']},
                   {:name => "email", :body => @params['email']}
                  ]
      ConnectionController.service_request("send_request_service_test.php",nil,"upload_file",nil, nil, url_for(:action => :http_callback), nil, multipart_array)
    end
    render :action => :wait
  end
  
  
    # This method prepares the data being send to the backend after a request from catalog has been initiated. If an image should be sent as well, it puts the data in a mulitpart array, in a string otherwise
  def submit_request_catalog
    if @params['hiddenImagePath'] == ''
      @data = "subject=Kataloganfrage aus Maco-Tec App&product=#{@params['product']}&rental_begin=#{@params['rental_begin']}&operation_period=#{@params['operation_period']}&amount_product=#{@params['amount_product']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&information=#{@params['information']}&hardware_id=#{Device.instance.hardware_id}&device_os=#{Device.instance.device_os}&locale=#{Device.instance.locale}&device_os_version=#{Device.instance.device_os_version}" 
      ConnectionController.service_request("send_request_rental_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    else
      multipart_array = [{:filename => @params['hiddenImagePath'], :name => "image", :content_type => "image/jpg"},
                   {:name => "hardware_id",:body => Device.instance.hardware_id},
                   {:name => "device_os",:body => Device.instance.device_os},
                   {:name => "locale",:body => Device.instance.locale},
                   {:name => "device_os_version",:body => Device.instance.device_os_version},
                   {:name => "action",:body => "submit_request_catalog"},
                   {:name => "subject",:body => "Kataloganfrage aus Maco-Tec App"},
                   {:name => "product", :body => @params['product']},
                   {:name => "rental_begin", :body => @params['rental_begin']},
                   {:name => "operation_period", :body => @params['operation_period']},
                   {:name => "amount_product", :body => @params['amount_product']},
                   {:name => "location", :body => @params['location']},
                   {:name => "company", :body => @params['company']},
                   {:name => "phone", :body => @params['phone']},
                   {:name => "email", :body => @params['email']},
                   {:name => "information", :body => @params['information']},
                  ]
      ConnectionController.service_request("send_request_rental_test.php",nil,"upload_file",nil, nil, url_for(:action => :http_callback), nil, multipart_array)
    end
    render :action => :wait
  end
  
    # This method prepares the data being send to the backend after a project request has been initiated. If an image should be sent as well, it puts the data in a mulitpart array, in a string otherwise
  def submit_request_project
    if @params['hiddenImagePath'] == ''
      @data = "subject=Anfrage zu Projekt aus Maco-Tec App&project_number=#{@params['project_number']}&information=#{@params['information']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&hardware_id=#{Device.instance.hardware_id}&device_os=#{Device.instance.device_os}&locale=#{Device.instance.locale}&device_os_version=#{Device.instance.device_os_version}"
      ConnectionController.service_request("send_request_project_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    else
      multipart_array = [{:filename => @params['hiddenImagePath'], :name => "image", :content_type => "image/jpg"},
                   {:name => "hardware_id",:body => Device.instance.hardware_id},
                   {:name => "device_os",:body => Device.instance.device_os},
                   {:name => "locale",:body => Device.instance.locale},
                   {:name => "device_os_version",:body => Device.instance.device_os_version},
                   {:name => "action",:body => "submit_request_project"},
                   {:name => "subject",:body => "Anfrage zu Projekt aus Maco-Tec App"},
                   {:name => "project_number", :body => @params['project_number']},
                   {:name => "information", :body => @params['information']},
                   {:name => "company", :body => @params['company']},
                   {:name => "phone", :body => @params['phone']},
                   {:name => "email", :body => @params['email']}
                  ]
      ConnectionController.service_request("send_request_project_test.php",nil,"upload_file",nil, nil, url_for(:action => :http_callback), nil, multipart_array)
    end
    render :action => :wait
  end
  
    # This method prepares the data being send to the backend after a rental request has been initiated. If an image should be sent as well, it puts the data in a mulitpart array, in a string otherwise
  def submit_request_rental
    if @params['hiddenImagePath'] == ''
      @data = "subject=Mietanfrage aus Maco-Tec App&product=#{@params['product']}&rental_begin=#{@params['rental_begin']}&operation_period=#{@params['operation_period']}&amount_product=#{@params['amount_product']}&location=#{@params['location']}&company=#{@params['company']}&phone=#{@params['phone']}&email=#{@params['email']}&information=#{@params['information']}&hardware_id=#{Device.instance.hardware_id}&device_os=#{Device.instance.device_os}&locale=#{Device.instance.locale}&device_os_version=#{Device.instance.device_os_version}" 
      ConnectionController.service_request("send_request_rental_test.php",nil,"post",nil, @data, url_for(:action => :http_callback))
    else
      multipart_array = [{:filename => @params['hiddenImagePath'], :name => "image", :content_type => "image/jpg"},
                   {:name => "hardware_id",:body => Device.instance.hardware_id},
                   {:name => "device_os",:body => Device.instance.device_os},
                   {:name => "locale",:body => Device.instance.locale},
                   {:name => "device_os_version",:body => Device.instance.device_os_version},
                   {:name => "action",:body => "submit_request_rental"},
                   {:name => "subject",:body => "Mietanfrage aus Maco-Tec App"},
                   {:name => "product", :body => @params['product']},
                   {:name => "rental_begin", :body => @params['rental_begin']},
                   {:name => "operation_period", :body => @params['operation_period']},
                   {:name => "amount_product", :body => @params['amount_product']},
                   {:name => "location", :body => @params['location']},
                   {:name => "company", :body => @params['company']},
                   {:name => "phone", :body => @params['phone']},
                   {:name => "email", :body => @params['email']},
                   {:name => "information", :body => @params['information']},
                  ]
      ConnectionController.service_request("send_request_rental_test.php",nil,"upload_file",nil, nil, url_for(:action => :http_callback), nil, multipart_array)
    end
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
  
  # The callback method of the submit methods. Calls the process_submit_result method and passes the backend status message 
  def http_callback
    # sleep 4
    if @params["status"] == "error"
      @answer_backend = {"submit_error_message"=> Localization::Request[:no_network]}
      WebView.navigate url_for :action => :request, :query => @answer_backend
    end
    @answer_backend = Rho::JSON.parse(@params["body"])
    WebView.navigate url_for :action => :process_submit_result, :query => @answer_backend
  end
  
  # This method is for choosing an image from the device gallery
  def choose_existing
    Camera::choose_picture(url_for(:action => :choose_existing_callback))
  end
  
  # This method makes the device take a picture using the local camera
  def new_image
    Camera::take_picture(url_for(:action => :camera_callback))
  end
  
  # Callback method of gallery chosen picture. Updates the view with the chosen image.
  def choose_existing_callback
    if @params['status'] == 'ok'
      WebView.execute_js('showImage("'+Rho::RhoApplication::get_blob_path(@params['image_uri'])+'");')
    end
  end
  
  # Callback method of new_image. Only saves on image and updates the view with it. If user takes another one, the image taken before will be deleted.
  def camera_callback
    @image = Image.find(:all)
    if @image.size > 0
      @image.each do |img|
        img.destroy
      end
    end
    if @params['status'] == 'ok'
      image = Image.new({'image_uri' => @params['image_uri']})
      image.save
      WebView.execute_js('showImage("'+Rho::RhoApplication::get_blob_path(image.image_uri)+'");')
    end
  end
  
  
  
  
  ##################################### Begin DateTimePicker (Strongly influenced by the DateTimeAJ Example Code at https://github.com/rhomobile/rhodes-system-api-samples/tree/master/app/DateTimeAJ ) ########################################
  
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
  
  
  
end