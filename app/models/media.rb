class Media
  include Mongoid::Document
  belongs_to :event

  field :md5
  field :caption
  field :media_url, type: String
  field :adult_content, type: Mongoid::Boolean
end
