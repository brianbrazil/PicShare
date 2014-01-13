class Event
  include Mongoid::Document
  has_many :medias

  field :name, type: String
end
