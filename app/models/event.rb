class Event
  has_many :medias
  include Mongoid::Document
  field :name, type: String
end
