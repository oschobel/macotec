require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'
require 'Connection/connection_controller'
require 'date'

class ProductController < Rho::RhoController
  include BrowserHelper
  
  def index
    ConnectionController.service_request("catalog.php?request=version",nil,"get",nil,nil,url_for(:action => :http_callback_catalog_version_check),nil,nil)
    product = Product.find(:all)
    if product.length < 1 
      date = "1980-03-14"
      # catalog_version = 0
    else
      date = product.first.catalog_date
      # catalog_version = product.first.catalog_version
    end
    if product.nil? || (product.length < 1) || (Date.parse(date) + 7) < (Date.today) 
      ConnectionController.service_request("catalog.php",nil,"get",nil,nil,url_for(:action => :http_callback),nil,nil)   
      render :action => :wait, :back => '/app'
    else
      @categories = Product.get_categories
      render :action => :index, :back => '/app'
    end
  end
  
  def wait
    
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
  
  def set_old_date
    Product.set_old_date
  end
  
  def http_callback_catalog_version_check
    puts @params.inspect
    puts "----------------------------- YEAH"
  end
  
  def http_callback
    if @params['http_error'] == "200"
      Product.update_product_list @params['body']
      sleep 2
      WebView.navigate url_for :action => :index
    else
      # Alert.show_popup({:message => 'No Internet Connection', :buttons => ['OK'], :callback => url_for(:controller => :Request, :action => :submit_failed)})
      WebView.navigate url_for :action => :catalog_failure
    end
    
  end
  
  
end