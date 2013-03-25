require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'
require 'Connection/connection_controller'
require 'date'

class ProductController < Rho::RhoController
  include BrowserHelper
  
  def index
      @categories = Product.get_categories
      Alert.hide_popup()
      render :action => :index, :back => '/app'
  end
  
  def wait
    
  end
  
  def product_list
    @categories = Product.get_categories
    render :action => :product_list
  end
  
  def sub_categories
    @category = @params['category']
    @sub_categories = Product.get_sub_categories(@params['category'])
    render :action => :sub_categories
  end
  
  def product_details
    @category = @params['category']
    @products = Product.get_products(@params['sub_category'])
    render :action => :product_details
  end
  
  def get_categories
    @products = Product.get_categories
  end
  
  def delete_catalog
    Product.delete_catalog
  end
  
  def catalog_failure
    render :action => :catalog_failure, :back => '/app'
  end
  
  def get_catalog_data
    puts "::::::::: get_catalog_data"
    @device_last_sync = Device.instance.last_sync
    @device_locale = Device.instance.locale
    @product = Product.find_all.first
    if @device_last_sync.nil? || @product.nil?
      puts @device_last_sync.nil?
      puts @product.nil?
      date = Date.today - 1
    else
      puts "else"
      puts Device.instance.last_sync.class
      date = Date.parse(Device.instance.last_sync)
    end
    if date < Date.today
      Alert.show_popup({:message => Localization::Product[:loading_catalog], 
                        :buttons => [Localization::System[:cancel]],
                        :title => "",
                        #:icon => '/public/images/loading.gif',
                        :callback => :cancel_callback})
      ConnectionController.service_request("catalog_" + @device_locale + ".php",nil,"get",nil,nil,url_for(:controller => :Product, :action => :http_callback),nil,nil)
    else
      WebView.navigate url_for :action => :index
    end
  end
  
  def cancel_callback
    Rho::AsyncHttp.cancel
    Alert.hide_popup
  end
  
  def http_callback
    if @params['http_error'] == "200"
      Product.update_product_list @params['body']
      # sleep 2
      Device.instance.last_sync = Date.today
      Device.instance.save
      WebView.navigate url_for :action => :index
    else
      Alert.hide_popup
      WebView.navigate url_for :action => :catalog_failure
    end
    
  end
  
  
end