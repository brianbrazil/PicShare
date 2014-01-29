class Event
  include Mongoid::Document
  has_many :medias

  field :name, type: String
  field :startDate, type: Date
  field :endDate, type: Date

  validates_presence_of :name, message: "Name is required"
  validates_presence_of :startDate, message: "Start Date is required"
  validates_presence_of :endDate, message: "End Date is required"
end
