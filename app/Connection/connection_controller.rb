require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class ConnectionController < Rho::RhoController
  
  include BrowserHelper
    
  SERVICE_HOST = Rho::RhoConfig.service_host
  APP_VERSION_KEY = Rho::RhoConfig.app_version_key
  
  
  def ConnectionController.service_request(path, query, method = 'GET', headers = {}, body = nil, callback = nil, callback_param = nil, multipart_array)
    
    headers = {"Content-Type" => "application/x-www-form-urlencoded","charset" => "UTF-8"}
    url = "#{SERVICE_HOST}#{path}"
    do_callback = false
    
    if callback != nil && callback.length > 0
      do_callback = true
    end
    
    if body
      body << "&app_version_key=#{APP_VERSION_KEY}"
    end
    
    if multipart_array
      multipart_array << {:name => "app_version_key",:body => "#{APP_VERSION_KEY}"}
    end
    
    
    case method
      when 'GET'
        res = Rho::AsyncHttp.get(
          :url => url,
          :headers => headers,
          :callback => callback ? callback : '',
          :callback_param => (callback_param)? callback_param : ''
        )
            
      when 'POST'
        res = Rho::AsyncHttp.post(
          :url => url,
          :http_command => method.upcase,
          :body => body ? body : '',
          :headers => headers,
          :callback => (callback)? callback : '',
          :callback_param => (callback_param)? callback_param : ''
        )
        
      when 'upload_file'
        res = Rho::AsyncHttp.upload_file(
          :url => url,
          :callback => (callback)? callback : '',
          :callback_param => (callback_param)? callback_param : '',
          :multipart => multipart_array
        )
    end
    
    return do_callback ? true : res
  end
  
  
end