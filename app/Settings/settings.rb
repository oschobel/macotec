class Settings
  include Rhom::FixedSchema
  
  property :company, :string
  property :phone, :string
  property :email, :string
  
  def self.has_user_data
    @data = getSavedData
    return false if @data.nil?
    return false if @data.company == "" && @data.phone == "" && @data.email == ""
    return true
  end
  
  def self.getSavedData
    @data = Settings.find(:all).first
    return @data
  end
  
  def self.removeSavedData
    Settings.delete_all
  end
  
end