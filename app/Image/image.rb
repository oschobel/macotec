# This class holds the image related data such as name, path etc.

class Image
  include Rhom::PropertyBag
  #include Rhom::FixedSchema

  enable :sync

  property :name, :string
  property :filename, :string
  property :image_uri, :blob, :overwrite
end