class Event
  include Mongoid::Document
  has_many :medias

  field :name, type: String
  field :startDate, type: Date
  field :endDate, type: Date
end
