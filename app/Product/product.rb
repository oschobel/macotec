class Product
  include Rhom::FixedSchema
  require 'json'
  require 'date'
  
  @@catalog_date = nil
  
  property :category, :string
  property :category_name, :string
  property :category_img_url, :string
    
  property :sub_category, :string
  property :sub_category_name, :string
  property :sub_category_img_url, :string
   
  property :details, :string
  property :details_name, :string
  property :detail_img_url, :string
  property :header, :string
  
  property :attribute_title_1, :string
  property :attribute_title_2, :string
  property :attribute_title_3, :string
  property :attribute_title_4, :string
  property :attribute_title_5, :string
  property :attribute_list_title, :string
  
  property :attribute_1, :string
  property :attribute_2, :string
  property :attribute_3, :string
  property :attribute_4, :string
  property :attribute_5, :string
  property :attribute_list, :string
  
  def self.get_categories
    cat = self.find(:all, :select => ['category','category_name'])
    if cat
      result = {}
      cat.each do |c|
        hash = {c.category => c.category_name}
        result.merge! hash 
      end
      return result
    end
  end
  
  def self.get_sub_categories(category)
    sub_cat = self.find(:all, :conditions => {{:name => 'category',:op => 'LIKE'} => category}, :select => ['sub_category','sub_category_name'])
    result = {}
    if sub_cat
      sub_cat.each do |s|
        hash = {s.sub_category => s.sub_category_name}
        result.merge! hash
      end      
    end
    return result
  end
  
  def self.get_products(sub_category)
    result = self.find(:all, :conditions => {{:name => 'sub_category',:op => 'LIKE'} => sub_category})
    return result
  end
  
  def self.delete_catalog
    puts "::::::::::::::::: delete catalog..."
    catalog_content = self.find(:all)
    puts ":::::::::::: first: catalog_content.length: #{catalog_content.length}"
    if catalog_content.length > 0
      catalog_content.each do |a|
        puts "------- destroy catalog object"
        a.destroy  
      end
    end
    puts ":::::::::::: second: catalog_content.length: #{self.find(:all).count}"
  end
  
  def self.catalog_date
    return @@catalog_date
  end
  
  def self.set_old_date
    @@catalog_date = Date.today - 1
  end
  
  def self.update_product_list json_string
    puts "::::::::::::::::::::::: update_product_list"
    puts "+++++++++++++++++++ first: catalog_content.size: #{self.find(:all).count}"
    all = self.find(:all)
    if all
      all.each do |a|
        a.destroy  
      end
    end
    
    puts "################### second: catalog_content.size: #{self.find(:all).count}"
    Rho::JSON.parse(json_string).each do|product|
      product.each_with_index do |item, index|
        unless index == 0
          puts "update..."
          pro = self.new
          pro.update_attributes(item)
        end
      end
    end
    if self.find(:all).count > 0
      @@catalog_date = Date.today
    end
    puts "---------------------- third: catalog_content.size: #{self.find(:all).count}"
  end
  
end