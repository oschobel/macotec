require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'

class ImageController < Rho::RhoController
  
  $camera_main = 'NONE'
  $camera_front = 'NONE'

  $use_new_api = true
  
  def new
    # @image = Image.find(:all)
    # if @image.size > 0
      # @image.each do |img|
        # img.destroy
      # end
    # end
    Camera::take_picture(url_for(:action => :camera_callback))
  end
  
  def on_take
    puts 'Image.on_take() !'
    en_ed = (@params['enable_editing'] == 'enable')
    pr_size = @params['preferred_size']
    width = 0
    height = 0
    if pr_size == 'size1'
        width = 1000
        height = 1000
    end
    if pr_size == 'size2'
        width = 100
        height = 100
    end
  end
  
  def save_to_gallery
    img = Image.find(@params['id'])
    Camera::save_image_to_device_gallery(Rho::RhoApplication::get_blob_path(img.image_uri))
    #redirect :action => :index
  end
  
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
      if (((System::get_property('platform') == 'ANDROID') || (System::get_property('platform') == 'APPLE')) && ($use_new_api))
           img_width = @params['image_width']
           img_height = @params['image_height']
           img_format = @params['image_format']
           puts "Captured Image  Size: #{img_width}x#{img_height}, Format: #{img_format} "
      end
    end  
  end
  
  def get_image_uri
    @image = Image.find(:all).first.image_uri.to_s
    render :string =>  @image.to_json
  end
  
end
