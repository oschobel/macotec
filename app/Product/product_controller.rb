require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ProductController < Rho::RhoController
  include BrowserHelper
  @layout = 'custom_layout'
  
  def index
    @products = Product.get_categories
    render :action => :index
  end
  
  def sub_categories
    @products = Product.get_category_entries(@params['product'])
    render :action => :sub_categories
  end
  
  def product_details
    @product = Product.get_product_details(@params['product'])
    render :action => :product_details
  end
  
  def get_categories
    @products = Product.get_categories
  end
  
end