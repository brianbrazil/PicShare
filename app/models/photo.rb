class Photo < Media
  include Mongoid::Document
  field :url, type: String
end
