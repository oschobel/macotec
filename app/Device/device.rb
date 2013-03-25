class Device
  include Rhom::FixedSchema
  require 'json'
  require 'date'
  require 'Connection/connection_controller'
  
  @@instance = nil
  property :device_id
  property :device_os
  property :last_sync
  property :language, :string
  property :device_os_version, :string
  property :token, :string
  property :model, :string
  
  def self.create_from_system
    d = self.new

    d.device_os = System.get_property('platform')
    d.device_os_version = System.get_property('os_version')

    d.model = System.get_property('device_name')

    d.token = System.get_property('device_id')
    d.hardware_id = System.get_property('phone_id')
  end
  
  def self.instance
    @@instance ||= self.get_device
  end
  
  def self.get_device
    instance = Device.find(:all)[0]
    # create a new session is none exists so far
    puts "found device:"
    puts instance
    return instance if(instance)
     
    device = self.create_from_system

    device.save
    device
  end
  
end


  
