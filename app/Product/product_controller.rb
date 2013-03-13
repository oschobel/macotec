require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'
require 'Connection/connection_controller'
require 'date'

class ProductController < Rho::RhoController
  include BrowserHelper
  
  def index
    puts "################ Date.today: #{Date.today}"
    puts "++++++++++++++++ Product.catalog_date: #{Product.catalog_date}"
    if Product.catalog_date.nil? || Product.find(:all).count < 1 || Product.catalog_date < Date.today 
      puts "calling backend to get catalog data............."
      Alert.show_popup({:message => 'Loading...', :buttons => []})
      ConnectionController.service_request("catalog.php",nil,"get",nil,nil,url_for(:action => :http_callback),nil,nil)   
      ""
    else
      @categories = Product.get_categories
      render :action => :index
    end
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
  
  def set_old_date
    Product.set_old_date
  end
  
  def http_callback
    puts "---------------- entered http_callback_update_catalog"
    Product.update_product_list @params['body']
    sleep 2
    Alert.hide_popup
    WebView.navigate url_for :action => :index
  end
  
  
end