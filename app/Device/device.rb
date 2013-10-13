# this class represents a model which holds all device related data

class Device
  include Rhom::FixedSchema
  require 'json'
  require 'date'
  require 'Connection/connection_controller'
  
  @@instance = nil
  property :hardware_id, :string
  property :device_os, :string
  property :last_sync, :date
  property :device_os_version, :string
  property :token, :string
  property :model, :string
  property :locale, :string
  
  def self.create_from_system
    d = self.new
    
    d.locale = System.get_property('locale')
    d.device_os = System.get_property('platform')
    d.device_os_version = System.get_property('os_version')

    d.model = System.get_property('device_name')

    d.token = System.get_property('device_id')
    d.hardware_id = System.get_property('phone_id')
    d.last_sync = Date.new
    d
  end
  
  def self.instance
    @@instance ||= self.get_device
  end
  
  # singleton delivers the only instance of Device  
  def self.get_device
    instance = Device.find(:all)[0]
    # create a new session if none exists so far
    puts "found device:"
    puts instance
    return instance if(instance)
     
    device = self.create_from_system
    puts "################ #{device.inspect}"
    device.save
    device
  end
  
end


  
